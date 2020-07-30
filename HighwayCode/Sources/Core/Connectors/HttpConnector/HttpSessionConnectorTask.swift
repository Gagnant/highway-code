//
//  HttpSessionConnectorTask.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 01.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class HttpSessionConnectorTask<Content: Encodable, Value: Decodable, Failure: Decodable & Error>: Cancellable {

    private let connector: HttpSessionConnector
    private let request: Request<Content, Value, Failure>

    init(connector: HttpSessionConnector, request: Request<Content, Value, Failure>) {
        self.connector = connector
        self.request = request
        self.isCancelled = false
    }

    // MARK: -

    private(set) var isCancelled: Bool

    func resume() {
        acquireAccessToken()
    }

    func cancel() {
        isCancelled = true
        sessionDataTask?.cancel()
        tokenGeneratationTask?.cancel()
    }

    // MARK: -

    private var tokenGeneratationTask: Cancellable?
    private var sessionDataTask: URLSessionDataTask?

    private func acquireAccessToken() {
        guard !isCancelled, sessionDataTask == nil else {
            return
        }
        let provider = connector.accessTokenProvider
        tokenGeneratationTask = provider!.generateAccessToken(success: didAcquireAccessToken, failure: didFail)
    }

    private func didAcquireAccessToken(_ accessToken: String) {
        guard !isCancelled else {
            return
        }
        do {
            let resourceRequest = try createSessionRequest(accessToken: accessToken)
            let dataTask = connector.session.dataTask(with: resourceRequest) { (data, response, error) in
                if let error = error {
                    self.didFail(error: error)
                } else if let response = response as? HTTPURLResponse, let data = data {
                    self.didReceive(response: response, data: data)
                } else {
                    self.didFail(error: NSError())
                }
            }
            self.sessionDataTask = dataTask
            dataTask.resume()
        } catch {
            return didFail(error: error)
        }
    }

    private func didReceive(response: HTTPURLResponse, data: Data) {
        do {
            if response.statusCode == 200 {
                let value = try connector.decoder.decode(Value.self, from: data)
                didSucceed(value: value)
            } else {
                let error = try connector.decoder.decode(Failure.self, from: data)
                didFail(error: error)
            }
        } catch {
            didFail(error: error)
        }
    }

    private func didFail(error: Error) {
        guard !isCancelled else {
            NSLog("[CANCELLED] Task did fail.")
            return
        }
        DispatchQueue.main.async { self.request.failure?(error) }
    }

    private func didSucceed(value: Value) {
        guard !isCancelled else {
            NSLog("[CANCELLED] Task did succeed.")
            return
        }
        DispatchQueue.main.async { self.request.success?(value) }
    }

    // MARK: -

    private func createSessionRequest(accessToken: String) throws -> URLRequest {
        var components = URLComponents()
        components.path = request.path
        components.queryItems = request.queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let resourceURL = components.url(relativeTo: connector.baseURL)!
        var sessionRequest = URLRequest(url: resourceURL)
        sessionRequest.timeoutInterval = request.timeout
        sessionRequest.httpMethod = request.method
        configureHeaders(request: &sessionRequest, accessToken: accessToken)
        try configureContent(request: &sessionRequest)
        return sessionRequest
    }

    private func configureHeaders(request: inout URLRequest, accessToken: String) {
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("1", forHTTPHeaderField: "vfx-version")
        request.setValue("3", forHTTPHeaderField: "vfx-device-os")
        request.setValue(accessToken, forHTTPHeaderField: "vfx-device-token")
    }

    private func configureContent(request: inout URLRequest) throws {
        guard let content = self.request.content else {
            return
        }
        request.httpBody = try connector.encoder.encode(content)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    }

}
