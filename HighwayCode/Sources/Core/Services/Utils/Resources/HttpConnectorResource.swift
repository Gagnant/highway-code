//
//  HttpConnectorResource.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class HttpConnectorResource<Content: Encodable, Value: Decodable, Failure: Decodable & Error>: Resource {

    private let connector: HttpConnector
    private var request: Request<Content, Value, Failure>

    // MARK: - Resource

    init(connector: HttpConnector, request: Request<Content, Value, Failure>) {
        self.connector = connector
        self.request = request
        isLoading = false
        observations = [:]
    }

    /// Value.
    private(set) var value: Value?

    /// Error.
    private(set) var error: Error?

    /// Is loading.
    private(set) var isLoading: Bool

    func update() {
        guard !(isLoading || observations.isEmpty) else {
            return
        }
        request.success = { [weak self] value in
            self?.error = nil
            self?.value = value
            self?.isLoading = false
            self?.didChange()
        }
        request.failure = { [weak self] error in
            self?.error = error
            self?.isLoading = false
            self?.didChange()
        }
        isLoading = true
        _ = connector.execute(request: request)
        didChange()
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

    var isRequired: Bool {
        return !observations.isEmpty
    }

    // MARK: -

    private var observations: [ObjectIdentifier: () -> Void]

    private func didRequireSubscription() {
        update()
    }

    private func didUnrequireSubscription() {
        // NOP
    }

    private func didChange() {
        observations.values.forEach { $0() }
    }

}
