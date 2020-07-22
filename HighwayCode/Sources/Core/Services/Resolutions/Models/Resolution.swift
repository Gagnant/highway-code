//
//  Resolution.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import CoreLocation

struct Resolution: Decodable {

    /// Resolution id.
    let id: Int

    /// Series.
    let series: String

    /// Number
    let number: String

    /// Vehicle.
    let vehicle: Vehicle

    /// The date the violation was committed.
    let violationDate: Date

    /// The date the resolution was created.
    let resolutionDate: Date

    /// Location where the violation was committed.
    let location: CLLocationCoordinate2D

    /// Media.
    let media: [ResolutionMedia]

    /// Price of related violation.
    let amount: Int

    /// Amount to pay in UAH coins.
    let payAmount: Int

    /// Defines is resolution was paid.
    let isPaid: Bool

    /// Violation text.
    let violationText: String

    // MARK: - Resolution

    private enum CodingKeys: String, CodingKey {
        case id, series, number = "num", violationDate, resolutionDate, media, amount, payAmount, isPaid, violationText
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        series = try container.decode(String.self, forKey: .series)
        number = try container.decode(String.self, forKey: .number)
        vehicle = try Vehicle(from: decoder)
        violationDate = try container.decode(Date.self, forKey: .violationDate)
        resolutionDate = try container.decode(Date.self, forKey: .resolutionDate)
        location = try CLLocationCoordinate2D(from: decoder)
        media = try container.decode([ResolutionMedia].self, forKey: .media)
        amount = try container.decode(Int.self, forKey: .amount)
        payAmount = try container.decode(Int.self, forKey: .payAmount)
        isPaid = try container.decode(Bool.self, forKey: .isPaid)
        violationText = try container.decode(String.self, forKey: .violationText)
    }

}
