//
//  CallableFunctionRequest.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 03.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct CallableFunctionRequest<Parameters: Encodable, Result: Decodable> {

    /// Method name.
    let method: String

    /// Parameters.
    let parameters: Parameters

    /// The timeout interval to use when waiting for additional data. If interval is
    /// less than or equal to 0.0, this method chooses the nonnegative value of
    /// 0.1 milliseconds instead. Default value is 120 seconds.
    var timeout: TimeInterval = 120.0

    /// Success block.
    var success: ((Result) -> Void)?

    /// Failure block.
    var failure: ((Error) -> Void)?

}
