//
//  HttpConnection.swift
//  transport
//
//  Created by Andrew Vysotskyi on 16.04.2020.
//  Copyright © 2020 Andrew Vysotskyi. All rights reserved.
//

import Foundation
import UIKit

final class HttpSessionConnector {

    /// Connector base URL.
    private let baseURL: URL

    /// Underlying session.
    private let session: URLSession

    /// Decoder used to parse incoming data.
    private let decoder: AnyTopLevelDecoder<Data>

    init(session: URLSession, baseURL: URL, decoder: AnyTopLevelDecoder<Data>) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
    }

}

extension HttpSessionConnector: HttpConnector {

    func task<Value: Decodable, Failure: Decodable & Error>(request: Request, errorType: Failure.Type, valueType: Value.Type) -> AnyHttpConnectorTask<Value> {
        let resourceRequest = createSessionRequest(for: request)
        let task = SessionDataTaskAdapter<Value>()
        task.adaptee = session.dataTask(with: resourceRequest) { [decoder] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    task.onFailure?(error)
                } else if let data = data {
                    do {
                        let value = try decoder.decode(Value.self, from: data)
                        task.onSuccess?(value)
                    } catch {
                        task.onFailure?(error)
                    }
                } else {
                    NSLog("Invalid calling convention!")
                }
            }
        }
        return AnyHttpConnectorTask(task)
    }

    func task<Failure: Decodable & Error>(request: Request, errorType: Failure.Type) -> AnyHttpConnectorTask<Void> {
        let resourceRequest = createSessionRequest(for: request)
        let task = SessionDataTaskAdapter<Void>()
        task.adaptee = session.dataTask(with: resourceRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    task.onFailure?(error)
                } else {
                    task.onSuccess?(())
                }
            }
        }
        return AnyHttpConnectorTask(task)
    }

    private func createSessionRequest(for request: Request) -> URLRequest {
        var components = URLComponents()
        components.path = request.path
        components.queryItems = request.queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let resourceURL = components.url(relativeTo: baseURL) else {
            fatalError("Invalid resource!")
        }
        var sessionRequest = URLRequest(url: resourceURL)
        sessionRequest.timeoutInterval = request.timeout
        sessionRequest.httpMethod = request.method

        sessionRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        sessionRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        sessionRequest.setValue("1", forHTTPHeaderField: "vfx-version")
        sessionRequest.setValue("3", forHTTPHeaderField: "vfx-device-os")
        sessionRequest.setValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "vfx-device-token")

        if let content = request.content {
            sessionRequest.httpBody = content.data
            sessionRequest.setValue(content.contentType, forHTTPHeaderField: "Content-Type")
        }
        return sessionRequest
    }

}


private class SessionDataTaskAdapter<Value>: HttpConnectorTask {

    weak var adaptee: URLSessionDataTask?

    // MARK: - HttpConnectorTask

    var onSuccess: ((Value) -> Void)?
    var onFailure: ((Error) -> Void)?

    func cancel() {
        adaptee?.cancel()
    }

    func resume() {
        adaptee?.resume()
    }

}
