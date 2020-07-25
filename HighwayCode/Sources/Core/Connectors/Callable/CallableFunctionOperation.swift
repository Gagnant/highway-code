//
//  CallableFunctionOperation.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import FirebaseFunctions

class CallableFunctionOperation<P: Encodable, R: Decodable>: Cancellable {

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let functions: Functions
    private let request: CallableFunctionRequest<P, R>

    private var isCancelled: Bool = false
    private var callable: HTTPSCallable?

    init(
        functions: Functions,
        decoder: JSONDecoder,
        encoder: JSONEncoder,
        request: CallableFunctionRequest<P, R>
    ) {
        self.functions = functions
        self.decoder = decoder
        self.encoder = encoder
        self.request = request
    }

    // MARK: -

    func cancel() {
        isCancelled = true
    }

    func resume() {
        assert(self.callable == nil)
        let callable = functions.httpsCallable(request.method)
        callable.timeoutInterval = request.timeout
        do {
            let data = try encode(request.parameters)
            callable.call(data, completion: processResponse)
        } catch {
            fail(with: error)
        }
        self.callable = callable
    }

    // MARK: -

    private func processResponse(result: HTTPSCallableResult?, error: Error?) {
        guard !isCancelled else {
            return
        }
        if let error = error {
            return fail(with: error)
        }
        if let result = result {
            do {
                let value = try decode(R.self, from: result.data)
                request.success?(value)
            } catch {
                fail(with: error)
            }
            return
        }
        NSLog("Invalid calling convention!")
    }

    private func fail(with error: Error) {
        request.failure?(error)
    }

    private func decode<T>(_ type: T.Type, from object: Any) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
        return try decoder.decode(T.self, from: data)
    }

    private func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

}
