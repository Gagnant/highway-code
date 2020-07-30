//
//  IFinesListInteractor.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

protocol FinesListInteractorDelegate: class {

    /// Invoked when content changes.
    func didChangeContent()

}

protocol IFinesListInteractor {

    /// Delegate.
    var delegate: FinesListInteractorDelegate? { get set }

    /// Starts interactor.
    func start()

    /// Stops ineractor.
    func stop()

    /// Triggers content update.
    func update()

    /// Determines whether interactor is loading.
    var isLoading: Bool { get }

    /// Unpaid resolutions.
    var unpaidResolutions: [Resolution] { get }

    /// Paid resolutions.
    var paidResolutions: [Resolution] { get }

    /// Extinguished resolutions.
    var extinguishedResolutions: [Resolution] { get }

    /// Determines whether given resolution is extinguished.
    func isExtinguished(resolutionId: Int) -> Bool

    /// Determines whether given resolution is paid.
    func isPaid(resolutionId: Int) -> Bool

}
