//
//  Subscription.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct VehicleSubscription: Decodable, Hashable {

    /// Subscription identifier.
    let id: Int

    /// Vehicle associated with subscription.
    let vehicle: Vehicle

    /// Subscription document.
    let document: String

    /// Defines whether subscription is successful.
    let isSuccessful: Bool

    // MARK: - Decodable

    private enum CodingKeys: String, CodingKey {
        case id, document, isSuccessful = "isSuccess"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        document = try container.decode(String.self, forKey: .document)
        isSuccessful = try container.decode(Bool.self, forKey: .isSuccessful)
        vehicle = try Vehicle(from: decoder)
    }

}
