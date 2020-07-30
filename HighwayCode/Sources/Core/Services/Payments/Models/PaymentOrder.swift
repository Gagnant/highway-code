//
//  PaymentOrder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 26.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

extension PaymentOrder {

    struct Resolution: Codable, Equatable {

        /// Resolution identifier.
        let id: Int

        /// Resolution series.
        let series: String

        /// Resolution number.
        let number: String

    }

    struct Payment: Codable, Equatable {

        /// Data.
        let data: String

        /// Signature.
        let signature: String

    }

    enum Status: String, Codable, Equatable {
        case draft, success, failure, progress
    }

}

struct PaymentOrder: Equatable {

    /// Order id.
    let id: String

    /// Payment amount in UAH.
    let amount: Decimal

    /// Resolution.
    let resolution: Resolution

    /// Date when order was updated last time.
    let updatedAt: Date

    /// Payment details.
    let payment: Payment

    /// Order status.
    let status: Status

}

extension PaymentOrder: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id, amount, resolution, updatedAt, payment, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        amount = try KeyedContainerDecimalDecodingProxy(container).decodeNumber(forKey: .amount)
        resolution = try container.decode(Resolution.self, forKey: .resolution)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        payment = try container.decode(Payment.self, forKey: .payment)
        status = try container.decode(Status.self, forKey: .status)
    }

}
