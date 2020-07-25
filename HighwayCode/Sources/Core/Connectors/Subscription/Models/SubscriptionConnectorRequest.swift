//
//  SubscriptionRequest.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 21.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct SubscriptionConnectorRequest<Result: Decodable> {

    /// Resource path.
    var path: String

    /// Determines if resource is publically available otherwise authentication is
    /// required.
    var isPublic: Bool = false

    /// Determines whether resource cache should be ignored.
    var isCacheIgnored: Bool = false

}
