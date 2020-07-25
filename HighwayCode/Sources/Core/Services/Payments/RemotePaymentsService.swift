//
//  RemotePaymentsService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class RemotePaymentsService: PaymentsService {

    private let connectors: ConnectorManager
    private weak var resolutionProvider: ResolutionProvider?

    init(connectors: ConnectorManager, resolutionProvider: ResolutionProvider) {
        self.connectors = connectors
        self.resolutionProvider = resolutionProvider
    }

    // MARK: -

    var orders: AnyResource<[PaymentOrder]> {
        return AnyResource(_orders)
    }

    func order(for resolutionId: Int) -> PaymentOrder? {
        guard let resolution = resolutionProvider?.resolution(for: resolutionId) else {
            return nil
        }
        let order = orders.value?.first {
            $0.amount == resolution.payAmount && resolutionId == $0.resolution.id
        }
        return order
    }

    func createOrder(for resolutionId: Int, success: @escaping (PaymentOrder) -> Void, failure: (() -> Void)?) {
        if let order = self.order(for: resolutionId) {
            return success(order)
        }
        guard let paymentRequest = self.paymentRequest(for: resolutionId) else {
            failure?()
            return
        }
        var request = CallableFunctionRequest<PaymentRequest, PaymentOrder>(method: "createOrder", parameters: paymentRequest)
        request.failure = { _ in
            failure?()
        }
        request.success = { order in
            // TODO: update local storage.
            success(order)
        }
        connectors.callable.call(request: request)
    }

    func isResolutionPaid(resolutionId: Int) -> Bool? {
        let isPaid = orders.value?.contains { order -> Bool in
            order.resolution.id == resolutionId && order.status == .success
        }
        return isPaid
    }

    // MARK: -

    private lazy var _orders: SubscriptionConnectorResource<[PaymentOrder]> = {
        let request = SubscriptionConnectorRequest<[PaymentOrder]>(path: "orders")
        return SubscriptionConnectorResource(connector: connectors.subscription, request: request)
    }()

    private func paymentRequest(for resolutionId: Int) -> PaymentRequest? {
        guard let resolution = resolutionProvider?.resolution(for: resolutionId) else {
            return nil
        }
        let request = PaymentRequest(
            amount: resolution.payAmount,
            resolution: PaymentOrder.Resolution(
                id: resolution.id,
                series: resolution.series,
                number: resolution.number
            ),
            language: Locale.current.languageCode
        )
        return request
    }

}

