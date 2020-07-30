//
//  HttpConnection.swift
//  transport
//
//  Created by Andrew Vysotskyi on 16.04.2020.
//  Copyright © 2020 Andrew Vysotskyi. All rights reserved.
//

import Foundation

final class HttpSessionConnector: HttpConnector {

    /// Access token provider.
    unowned var accessTokenProvider: AccessTokenProvider!

    /// Connector base URL.
    let baseURL: URL

    /// Underlying session.
    let session: URLSession

    /// Decoder used to parse incoming data.
    let decoder: AnyTopLevelDecoder<Data>

    /// Encoder.
    let encoder: JSONEncoder

    init(session: URLSession, baseURL: URL, decoder: AnyTopLevelDecoder<Data>, encoder: JSONEncoder) {
        self.session = session
        self.baseURL = baseURL
        self.decoder = decoder
        self.encoder = encoder
    }

    // MARK: - HttpConnector

    func execute<Content: Encodable, Value: Decodable, Failure: Decodable & Error>(request: Request<Content, Value, Failure>) -> Cancellable {
        let task = HttpSessionConnectorTask(connector: self, request: request)
        task.resume()
        return task
    }

}

