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
        return _orders.map { Array($0.values) }
    }

    func order(for resolutionId: Int) -> PaymentOrder? {
        guard let resolution = resolutionProvider?.resolution(id: resolutionId) else {
            return nil
        }
        let order = orders.value?.first {
            $0.amount == resolution.payAmount && resolutionId == $0.resolution.id
        }
        return order
    }

    func createOrder(for resolutionId: Int, success: @escaping (PaymentOrder) -> Void, failure: (() -> Void)?) {
        if let order = self.order(for: resolutionId), order.status == .draft {
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
        request.success = { [weak self] order in
            self?.didCreateOrder(order)
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

    private lazy var _orders: MutableResourceDecorator<[String: PaymentOrder]> = {
        let request = SubscriptionConnectorRequest<[PaymentOrder]>(path: "orders")
        let resource = SubscriptionConnectorResource(connector: connectors.subscription, request: request).map {
            return Dictionary(uniqueKeysWithValues: $0.lazy.map { ($0.id, $0) })
        }
        return MutableResourceDecorator(resource: resource)
    }()

    private func didCreateOrder(_ order: PaymentOrder) {
        var currentOrders = _orders.value ?? [:]
        guard currentOrders[order.id] == nil else {
            return
        }
        currentOrders[order.id] = order
        _orders.value = currentOrders
        _orders.didChange()
    }

    private func paymentRequest(for resolutionId: Int) -> PaymentRequest? {
        guard let resolution = resolutionProvider?.resolution(id: resolutionId) else {
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

