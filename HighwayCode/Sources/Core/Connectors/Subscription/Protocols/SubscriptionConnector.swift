//
//  SubscriptionConnector.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 21.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol SubscriptionConnector {

    /// Subscribes for resource with request.
    /// - Parameters:
    ///   - request: subscription parameters.
    ///   - subscription: subscription block to invoke.
    /// - Returns: subscription token.
    func subscribe<Result>(request: SubscriptionConnectorRequest<Result>, subscription: @escaping (Result) -> Void) -> AnyHashable

    /// Removes given subscription
    /// - Parameter subscribtion: subscription.
    func cancelSubscription(_ subscribtion: AnyHashable)

}
