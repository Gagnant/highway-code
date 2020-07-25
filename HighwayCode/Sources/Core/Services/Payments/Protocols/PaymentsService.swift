//
//  PaymentsService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol PaymentsService: class {

    /// Available orders.
    var orders: AnyResource<[PaymentOrder]> { get }

    /// Creates order for given resolution.
    func createOrder(
        for resolutionId: Int, success: @escaping (PaymentOrder) -> Void, failure: (() -> Void)?
    )

    /// Checks if resolution is paid. Returns `nil` if payment status is unknown.
    func isResolutionPaid(resolutionId: Int) -> Bool?

}
