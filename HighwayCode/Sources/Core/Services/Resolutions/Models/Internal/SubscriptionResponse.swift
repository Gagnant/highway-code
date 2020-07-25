//
//  SubscriptionResponse.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct SubscriptionResponse: Decodable {

    /// Subscription.
    let subscription: VehicleSubscription

    /// Resolutions.
    let resolutions: [Resolution]

}
