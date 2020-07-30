//
//  RemoteResolutionsService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class RemoteResolutionsService: ResolutionsService, ResolutionProvider {

    private let connectors: ConnectorManager
    private let encoder: JSONEncoder

    init(connectors: ConnectorManager, encoder: JSONEncoder) {
        self.connectors = connectors
        self.encoder = encoder
    }

    // MARK: -

    var subscriptions: AnyResource<[VehicleSubscription]> {
        return _subscriptions.map { $0.values.sorted { $0.vehicle.plate < $1.vehicle.plate } }
    }

    var resolutions: AnyResource<[Resolution]> {
        return _resolutions.map { $0.values.sorted { $0.violationDate < $1.violationDate } }
    }

    func subscribe(document: String, vehicle: String, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        let content = SubscriptionRequest(document: document, savePersistent: true, vehiclePlate: vehicle)
        var request = Request<SubscriptionRequest, SubscriptionResponse, ServiceError>(
            method: "POST", path: "subscribe", content: content
        )
        request.success = { [weak self] response in
            self?.didSubscribe(subscription: response)
            success()
        }
        request.failure = { [weak self] failure in
            // Workaround for the shitty MIU API behaviour. 107 error code means that vehicle was
            // added to subscriptions but there are no resolutions for it which is totally fine.
            if let failure = failure as? ServiceError, failure.code == 107 {
                // Since actual subscription is unknown here we are simply triggering
                // refresh.
                self?.triggerUpdate()
                success()
            } else {
                error(failure)
            }
        }
        _ = connectors.http.execute(request: request)
    }

    func remove(subscriptionId: Int, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        var request = Request<[String: Int], VoidCodable, ServiceError>(
            method: "DELETE", path: "subscribe_resolution", content: ["id": subscriptionId]
        )
        request.success = { [weak self] _ in
            self?.didCancelSubscription(id: subscriptionId)
            success()
        }
        request.failure = error
        _ = connectors.http.execute(request: request)
    }

    func resolution(id: Int) -> Resolution? {
        return resolutions.value?.first { $0.id == id }
    }

    func subscription(id: Int) -> VehicleSubscription? {
        return subscriptions.value?.first { $0.id == id }
    }

    // MARK: - Private

    private lazy var _subscriptions: MutableResourceDecorator<[Int: VehicleSubscription]> = {
        let request = Request<VoidCodable, SubscriptionsListResponse, ServiceError>(method: "GET", path: "subscriptions")
        let resource = HttpConnectorResource(connector: connectors.http, request: request).map {
            return Dictionary(uniqueKeysWithValues: $0.subscriptions.lazy.map { ($0.id, $0) })
        }
        return MutableResourceDecorator(resource: resource)
    }()

    private lazy var _resolutions: MutableResourceDecorator<[Int: Resolution]> = {
        let request = Request<VoidCodable, ResolutionsListResponse, ServiceError>(method: "GET", path: "resolutions")
        let resource = HttpConnectorResource(connector: connectors.http, request: request).map {
            Dictionary(uniqueKeysWithValues: $0.resolutions.lazy.map { ($0.id, $0) })
        }
        return MutableResourceDecorator(resource: resource)
    }()

    private func didSubscribe(subscription response: SubscriptionResponse) {
        if _subscriptions.value?[response.subscription.id] == nil {
            _subscriptions.value = _subscriptions.value ?? [:]
            _subscriptions.value?[response.subscription.id] = response.subscription
            _subscriptions.didChange()
        }
        for resolution in response.resolutions {
            guard _resolutions.value?[resolution.id] == nil else {
                return
            }
            _resolutions.value = _resolutions.value ?? [:]
            _resolutions.value?[resolution.id] = resolution
            _resolutions.didChange()
        }
        triggerUpdate()
    }

    private func didCancelSubscription(id: Int) {
        _subscriptions.value?[id] = nil
        _subscriptions.didChange()
        triggerUpdate()
    }

    private func triggerUpdate() {
        subscriptions.update()
        resolutions.update()
    }

}
