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


    private lazy var _subscriptions: HttpConnectorResource<SubscriptionsListResponse, ServiceError> = {
        let request = Request(method: "GET", path: "subscriptions")
        return HttpConnectorResource<SubscriptionsListResponse, ServiceError>(connector: connectors.http, request: request)
    }()


    private lazy var _resolutions: HttpConnectorResource<ResolutionsListResponse, ServiceError> = {
        let request = Request(method: "GET", path: "resolutions")
        return HttpConnectorResource<ResolutionsListResponse, ServiceError>(connector: connectors.http, request: request)
    }()




    var subscriptions: AnyResource<[VehicleSubscription]> {
        return _subscriptions.map { $0.subscriptions }
    }

    var resolutions: AnyResource<[Resolution]> {
        return _resolutions.map { $0.resolutions }
    }

    func subscribe(document: String, vehicle: String, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        let subscriptionRequest = SubscriptionRequest(
            document: document, savePersistent: true, vehiclePlate: vehicle
        )
        let content = RawDataContent(
            data: try! encoder.encode(subscriptionRequest), mediaType: "application/json"
        )
        let request = Request(method: "POST", path: "subscribe", content: content)
        var task = connectors.http.task(request: request, errorType: ServiceError.self, valueType: SubscriptionResponse.self)
        task.onSuccess = { [weak self] response in
            self?.didSubscribe(subscription: response)
            success()
        }
        task.onFailure = error
        task.resume()
    }

    func remove(subscriptionId: Int, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        // TODO: add logic
        fatalError()
    }

    func resolution(for id: Int) -> Resolution? {
        return resolutions.value?.first { $0.id == id }
    }

    // MARK: - Private

    private func didSubscribe(subscription: SubscriptionResponse) {
//        var activeSubscriptions = _subscriptions.value?.subscriptions.filter {
//            return $0.id != subscription.subscription.id
//        } ?? []
//        activeSubscriptions.append(subscription.subscription)
//        _subscriptions.value = SubscriptionsResponse(subscriptions: activeSubscriptions)
//        _subscriptions.didChanged()
        subscriptions.update()
        resolutions.update()

    }

}
