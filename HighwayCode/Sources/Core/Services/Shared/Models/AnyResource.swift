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

    func attach(_ observer: AnyObject, observation: @escaping () -> Void) {
        box.attach(observer, observation: observation)
    }

    func remove(_ observer: AnyObject) {
        box.remove(observer)
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

    func attach(_ observer: AnyObject, observation: @escaping () -> Void) {
        fatalError("Must override")
    }

    func remove(_ observer: AnyObject) {
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

    override func attach(_ observer: AnyObject, observation: @escaping () -> Void) {
        resource.attach(observer, observation: observation)
    }

    override func update() {
        resource.update()
    }

}
