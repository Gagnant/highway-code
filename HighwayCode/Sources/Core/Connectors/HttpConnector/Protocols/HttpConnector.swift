//
//  HttpConnector.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol HttpConnector {

    /// Invokes method with given request.
    /// - Parameters:
    ///   - request: request.
    ///   - errorType: response error type.
    ///   - valueType: expected response value type.
    func execute<Content: Encodable, Value: Decodable, Failure: Decodable & Error>(request: Request<Content, Value, Failure>) -> Cancellable

}
