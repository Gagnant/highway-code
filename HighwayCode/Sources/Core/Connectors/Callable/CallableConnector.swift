//
//  ISuspendingFunctionConnectionOption.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 03.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol CallableConnector {

    /// Invokes connector with given request.
    @discardableResult
    func call<P: Encodable, R: Decodable>(request: CallableFunctionRequest<P, R>) -> Cancellable

}
