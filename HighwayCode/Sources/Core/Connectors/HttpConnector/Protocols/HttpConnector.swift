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
    func task<Value: Decodable, Failure: Decodable & Error>(request: Request, errorType: Failure.Type, valueType: Value.Type) -> AnyHttpConnectorTask<Value>

    /// Invokes method with given request.
    /// - Parameters:
    ///   - request: request.
    ///   - errorType: response error type.
    func task<Failure: Decodable & Error>(request: Request, errorType: Failure.Type) -> AnyHttpConnectorTask<Void>

}
