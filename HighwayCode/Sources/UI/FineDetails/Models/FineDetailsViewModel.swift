//
//  FineDetailsViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import CoreLocation
import DifferenceKit

struct FineDetailsViewModel {

    struct Media: Equatable {

        enum ContentType: Int {
            case image, video
        }

        /// Media type.
        let type: ContentType

        /// Media resource
        let url: URL

        /// Main action handler.
        let action: TaggedClosureBox<Void, Void>?

    }

    /// Series.
    let series: String

    /// Number
    let number: String

    /// Vehicle plate number.
    let vehiclePlate: String

    /// Violation text.
    let violationText: String

    /// The date the violation was committed.
    let violationDate: Date

    /// The date the resolution was created.
    let resolutionDate: Date

    /// Location where the violation was committed.
    let location: CLLocationCoordinate2D

    /// Media.
    let media: [Media]

    /// Price of related violation.
    let amount: Decimal

    /// Amount to pay in UAH.
    let payAmount: Decimal

    /// Defines is resolution was paid.
    let isPaid: Bool

    /// Defines if payment was accepted.
    let isPaymentApproved: Bool

}

extension FineDetailsViewModel.Media: Differentiable {

    var differenceIdentifier: String {
        return url.absoluteString
    }

}
