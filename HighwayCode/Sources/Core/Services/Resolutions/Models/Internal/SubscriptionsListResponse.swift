//
//  SubscriptionsListResponse.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct SubscriptionsListResponse: Decodable {

    /// Subscription.
    let subscriptions: [VehicleSubscription]

}
