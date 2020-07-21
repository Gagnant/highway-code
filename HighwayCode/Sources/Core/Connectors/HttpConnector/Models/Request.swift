//
//  Request.swift
//  transport
//
//  Created by Andrew Vysotskyi on 16.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct Request {

    /// Method type.
    var method: String

    /// Method path.
    var path: String

    /// Query items.
    var queryItems: [String: String] = [:]

    /// Parameters.
    var content: RequestContent? = nil

    /// If during a connection attempt the request remains idle for longer
    /// than the timeout interval, the request is considered to have timed
    /// out. The default timeout interval is 60 seconds.
    var timeout: TimeInterval = 60

}
