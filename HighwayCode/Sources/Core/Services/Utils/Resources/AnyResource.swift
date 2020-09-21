//
//  AnyResource.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct AnyResource<Value>: Resource {

    private let box: AnyResourceBase<Value>

    init<R: Resource>(_ resource: R) where R.Value == Value {
        box = AnyResourceBox(resource)
    }

    var value: Value? {
        return box.value
    }

    var error: Error? {
        return box.error
    }

    var isLoading: Bool {
        return box.isLoading
    }

    func update() {
        box.update()
    }

    func require(_ observer: AnyObject, observation: @escaping () -> Void) {
        box.require(observer, observation: observation)
    }

    func unrequire(_ observer: AnyObject) {
        box.unrequire(observer)
    }

    var isRequired: Bool {
        return box.isRequired
    }

}


private class AnyResourceBase<Value>: Resource {

    var value: Value? {
        fatalError("Must override")
    }

    var error: Error? {
        fatalError("Must override")
    }

    var isLoading: Bool {
        fatalError("Must override")
    }

    func update() {
        fatalError("Must override")
    }

    func require(_ observer: AnyObject, observation: @escaping () -> Void) {
        fatalError("Must override")
    }

    func unrequire(_ observer: AnyObject) {
        fatalError("Must override")
    }

    var isRequired: Bool {
        fatalError("Must override")
    }

}

private final class AnyResourceBox<R: Resource>: AnyResourceBase<R.Value> {

    private var resource: R

    init(_ resource: R) {
        self.resource = resource
    }

    override var value: R.Value? {
        return resource.value
    }

    override var error: Error? {
        return resource.error
    }

    override var isLoading: Bool {
        return resource.isLoading
    }

    override func require(_ observer: AnyObject, observation: @escaping () -> Void) {
        resource.require(observer, observation: observation)
    }

    override func unrequire(_ observer: AnyObject) {
        resource.unrequire(observer)
    }

    override func update() {
        resource.update()
    }

    override var isRequired: Bool {
        return resource.isRequired
    }

}
