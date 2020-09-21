//
//  Resource.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

protocol Resource {

    associatedtype Value

    /// Resource value.
    var value: Value? { get }

    /// Recent resource loading error.
    var error: Error? { get }

    /// Determines whether resource is beeing loaded.
    var isLoading: Bool { get }

    /// Updates the resource. Call is ignored if loading is in progress.
    func update()

    /// Requires resource.
    func require(_ observer: AnyObject, observation: @escaping () -> Void)

    /// Unrequires resource.
    func unrequire(_ observer: AnyObject)

    /// Returns true if resource has at least one observer attached.
    var isRequired: Bool { get }

}

protocol CollectionResource: Resource where Value: Collection {

    /// Loads more values if available.
    func more()

    /// Returns true if more items can be loaded.
    var isMoreAvailable: Bool { get }

}
