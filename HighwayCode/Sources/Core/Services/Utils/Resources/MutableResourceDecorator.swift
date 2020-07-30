//
//  MutableResourceDecorator.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 01.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

final class MutableResourceDecorator<Value>: Resource where Value: Equatable {

    private let resource: AnyResource<Value>

    init<R: Resource>(resource: R) where R.Value == Value {
        self.resource = AnyResource(resource)
        self.observations = [:]
        updateFromDecoratedResource()
    }

    // MARK: -

    /// Mutable resource value.
    var value: Value?

    var error: Error? {
        return resource.error
    }

    var isLoading: Bool {
        return resource.isLoading
    }

    func update() {
        resource.update()
    }

    func require(_ observer: AnyObject, observation: @escaping () -> Void) {
        let observationProxy = { [weak self] in
            self?.updateFromDecoratedResource()
            observation()
        }
        self.observations[ObjectIdentifier(observer)] = observation
        resource.require(observer, observation: observationProxy)
    }

    func unrequire(_ observer: AnyObject) {
        self.observations[ObjectIdentifier(observer)] = nil
        resource.unrequire(observer)
    }

    func didChange() {
        assert(Thread.current == .main)
        observations.values.forEach { $0() }
    }

    // MARK: -

    private var observations: [ObjectIdentifier: () -> Void]
    private var referenceValue: Value?

    private func updateFromDecoratedResource() {
        if referenceValue != resource.value {
            self.value = resource.value
        }
        self.referenceValue = resource.value
    }

}
