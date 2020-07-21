//
//  HttpConnectorTask.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol HttpConnectorTask {

    /// Expected result type.
    associatedtype Value

    /// The completion handler to call when the load request is succeded. This handler is executed on the
    /// delegate queue.
    var onSuccess: ((Value) -> Void)? { get set }

    /// The completion handler to call when the load request is failed. This handler is executed on the
    /// delegate queue. An error object that indicates why the request failed.
    var onFailure: ((Error) -> Void)? { get set }

    /// Cancels the task.
    ///
    /// This method returns immediately, marking the task as being canceled. Once a task is marked
    /// as being canceled, `onFailure` closure will be invoked, passing an error in the domain
    /// NSURLErrorDomain with the code NSURLErrorCancelled.
    func cancel()

    /// Resumes the task, if it is suspended.
    ///
    /// Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
    func resume()

}
