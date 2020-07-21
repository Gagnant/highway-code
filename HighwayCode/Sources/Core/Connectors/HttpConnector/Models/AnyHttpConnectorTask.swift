//
//  AnyHttpConnectorTask.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct AnyHttpConnectorTask<Value>: HttpConnectorTask {

    private let box: AnyHttpConnectorTaskBase<Value>

    init<Task: HttpConnectorTask>(_ task: Task) where Task.Value == Value {
        box = AnyHttpConnectorTaskBox(task)
    }

    var onSuccess: ((Value) -> Void)? {
        get { box.onSuccess }
        set { box.onSuccess = newValue }
    }

    var onFailure: ((Error) -> Void)? {
        get { box.onFailure }
        set { box.onFailure = newValue }
    }

    func cancel() {
        box.cancel()
    }

    func resume() {
        box.resume()
    }

}

private class AnyHttpConnectorTaskBase<Value>: HttpConnectorTask {

    var onSuccess: ((Value) -> Void)? {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }

    var onFailure: ((Error) -> Void)? {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }

    func cancel() {
        fatalError("Must override")
    }

    func resume() {
        fatalError("Must override")
    }

}

private final class AnyHttpConnectorTaskBox<Task: HttpConnectorTask>: AnyHttpConnectorTaskBase<Task.Value> {

    private var task: Task

    init(_ task: Task) {
        self.task = task
    }

    override var onSuccess: ((Task.Value) -> Void)? {
        get { task.onSuccess }
        set { task.onSuccess = newValue }
    }

    override var onFailure: ((Error) -> Void)? {
        get { task.onFailure }
        set { task.onFailure = newValue }
    }

    override func cancel() {
        task.cancel()
    }

    override func resume() {
        task.resume()
    }

}
