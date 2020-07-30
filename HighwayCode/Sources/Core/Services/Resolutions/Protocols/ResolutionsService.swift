//
//  ResolutionsService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol ResolutionsService {

    /// Subscriptions.
    var subscriptions: AnyResource<[VehicleSubscription]> { get }

    /// Returns resolutions for given subscription.
    /// - Parameter subscription: subscription.
    var resolutions: AnyResource<[Resolution]> { get }

    /// Returns resolution for given id if any.
    func resolution(id: Int) -> Resolution?

    /// Subscribes for updates for given vehicle.
    /// - Parameters:
    ///   - document: document.
    ///   - vehicle: vehicle.
    func subscribe(
        document: String, vehicle: String, success: @escaping () -> Void, error: @escaping (Error) -> Void
    )

    /// Returns subscription for given id if any.
    func subscription(id: Int) -> VehicleSubscription?

    /// Cancells given subscription.
    func remove(subscriptionId: Int, success: @escaping () -> Void, error: @escaping (Error) -> Void)

}
