//
//  MulticastDelegate.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 21.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

/// Represents a multicast delegate; that is, a delegate that can have more than
/// one element in its invocation list.
final class MulticastDelegate<T> {

    private let delegates: NSHashTable<AnyObject>

    /// Use this method to initialize a new MulticastDelegate specifying whether
    /// delegate references should be weak or strong.
    /// - Parameter strongReferences: whether delegates should be
    /// strongly referenced, false by default.
    init(strongReferences: Bool = false) {
        delegates = strongReferences ? NSHashTable<AnyObject>() : NSHashTable<AnyObject>.weakObjects()
    }

    /// Use this method to add a delelgate.
    /// - Parameter delegate: the delegate to add.
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    /// Use this method to remove a previously-added delegate.
    /// - Parameter delegate: the delegate to remove.
    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }

    /// Use this method to invoke a closure on each delegate.
    /// - Parameter invocation: The closure to invoke on each delegate.
    func invoke(_ invocation: (T) -> ()) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }

}
