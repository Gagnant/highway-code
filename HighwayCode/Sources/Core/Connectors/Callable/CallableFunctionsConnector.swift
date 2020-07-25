//
//  CallableFunctionsConnector.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 01.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import FirebaseFunctions

class CallableFunctionsConnector: CallableConnector {

    private let functions: Functions
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(functions: Functions, decoder: JSONDecoder, encoder: JSONEncoder) {
        self.functions = functions
        self.decoder = decoder
        self.encoder = encoder
    }

    func call<P: Encodable, R: Decodable>(request: CallableFunctionRequest<P, R>) -> Cancellable {
        let operation = CallableFunctionOperation(
            functions: functions, decoder: decoder, encoder: encoder, request: request
        )
        operation.resume()
        return operation
    }

}
