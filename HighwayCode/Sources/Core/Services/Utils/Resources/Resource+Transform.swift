//
//  ResourceTransform.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class ResourceTransformDecorator<Value, Input>: Resource {

    private let resource: AnyResource<Input>
    private let transform: (Input) -> Value

    init<R: Resource>(resource: R, transform: @escaping (Input) -> Value) where R.Value == Input {
        self.resource = AnyResource(resource)
        self.transform = transform
    }

    var value: Value? {
        return resource.value.map(transform)
    }

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
        resource.require(observer, observation: observation)
    }

    func unrequire(_ observer: AnyObject) {
        resource.unrequire(observer)
    }

    var isRequired: Bool {
        return resource.isRequired
    }

}

extension Resource {

    func map<T>(tranform: @escaping (Value) -> T) -> AnyResource<T> {
        return AnyResource(ResourceTransformDecorator(resource: self, transform: tranform))
    }

}
