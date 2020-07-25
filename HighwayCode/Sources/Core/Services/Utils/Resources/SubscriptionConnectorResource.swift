//
//  SubscriptionConnectorResource.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class SubscriptionConnectorResource<Value: Decodable>: Resource {

    private let connector: SubscriptionConnector
    private let request: SubscriptionConnectorRequest<Value>

    private var observations: [ObjectIdentifier: () -> Void]
    private var subscription: AnyHashable?

    // MARK: - Resource

    init(connector: SubscriptionConnector, request: SubscriptionConnectorRequest<Value>) {
        self.connector = connector
        self.request = request
        observations = [:]
    }

    private(set) var value: Value?

    var error: Error? {
        return nil
    }

    var isLoading: Bool {
        return value == nil
    }

    func update() {
        // Ignored
    }

    func require(_ observer: AnyObject, observation: @escaping () -> Void) {
        let identifier = ObjectIdentifier(observer)
        guard observations[identifier] == nil else {
            NSLog("Observation for given observer is already registerd!")
            return
        }
        observations[identifier] = observation
        didRequireSubscription()
    }

    func unrequire(_ observer: AnyObject) {
        let identifier = ObjectIdentifier(observer)
        observations[identifier] = nil
        didUnrequireSubscription()
    }

    // MARK: - Private

    private func didRequireSubscription() {
        guard subscription == nil else {
            return
        }
        subscription = connector.subscribe(request: request) { [weak self] value in
            self?.value = value
            self?.didChange()
        }
    }

    private func didUnrequireSubscription() {
        guard let subscription = subscription else {
            return
        }
        connector.cancelSubscription(subscription)
        self.subscription = nil
    }

    private func didChange() {
        observations.values.forEach { $0() }
    }

}
