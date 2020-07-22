//
//  ResolutionsService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

protocol ResolutionsService {

    /// Subscriptions.
    var subscriptions: AnyResource<SubscriptionsResponse> { get }

    /// Returns resolutions for given subscription.
    /// - Parameter subscription: subscription.
    var resolutions: AnyResource<ResolutionsResponse> { get }

    /// Subscribes for updates for given vehicle.
    /// - Parameters:
    ///   - document: document.
    ///   - vehicle: vehicle.
    func subscribe(document: String, vehicle: String, success: @escaping () -> Void, error: @escaping (Error) -> Void)

    /// Cancells given subscription.
    func remove(subscription: Subscription, success: @escaping () -> Void, error: @escaping (Error) -> Void)

}

class RemoteResolutionsService: ResolutionsService {

    private let connectors: ConnectorManager
    private let encoder: JSONEncoder

    init(connectors: ConnectorManager, encoder: JSONEncoder) {
        self.connectors = connectors
        self.encoder = encoder
    }

    // MARK: -

    private lazy var _subscriptions: HttpResource<SubscriptionsResponse, ServiceError> = {
        let request = Request(method: "GET", path: "subscriptions")
        return HttpResource<SubscriptionsResponse, ServiceError>(connector: connectors.http, request: request)
    }()

    private lazy var _resolutions: HttpResource<ResolutionsResponse, ServiceError> = {
        let request = Request(method: "GET", path: "resolutions")
        return HttpResource<ResolutionsResponse, ServiceError>(connector: connectors.http, request: request)
    }()

    var subscriptions: AnyResource<SubscriptionsResponse> {
        return AnyResource(_subscriptions)
    }

    var resolutions: AnyResource<ResolutionsResponse> {
        return AnyResource(_resolutions)
    }

    func subscribe(document: String, vehicle: String, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        let subscriptionRequest = SubscriptionRequest(document: document, savePersistent: true, vehiclePlate: vehicle)
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

    func remove(subscription: Subscription, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        // TODO: add logic
        fatalError()
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

struct SubscriptionRequest: Encodable {

    /// Docuement.
    let document: String

    /// Should be associated with user on remote.
    let savePersistent: Bool

    /// Vehicle plate.
    let vehiclePlate: String

}

struct SubscriptionResponse: Decodable {

    /// Subscription.
    let subscription: Subscription

    /// Resolutions.
    let resolutions: [Resolution]

}

struct SubscriptionsResponse: Decodable {

    /// Subscription.
    let subscriptions: [Subscription]

}

struct ResolutionsResponse: Decodable {

    /// Resolutions.
    let resolutions: [Resolution]

}

protocol Cancellable {

    func cancel()

}
