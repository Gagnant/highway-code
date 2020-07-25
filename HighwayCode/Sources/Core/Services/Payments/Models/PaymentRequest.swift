//
//  PaymentRequest.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct PaymentRequest: Encodable {

    /// Payment amount in UAH.
    let amount: Decimal

    /// Resolution.
    let resolution: PaymentOrder.Resolution

    /// Language.
    let language: String?

    // MARK: -

    private enum CodingKeys: String, CodingKey {
        case amount, resolution, language
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try KeyedContainerDecimalEncodingProxy(container).encode(amount, forKey: .amount)
        try container.encode(resolution, forKey: .resolution)
        try container.encodeIfPresent(language, forKey: .language)
    }

}
