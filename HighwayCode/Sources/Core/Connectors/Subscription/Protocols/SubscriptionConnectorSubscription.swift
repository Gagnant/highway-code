//
//  SubscriptionConnectorSubscription.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 21.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol SubscriptionConnectorSubscription {

    /// Resumes subscription.
    func resume()

    /// Cancels subscription.
    func cancel()

}
