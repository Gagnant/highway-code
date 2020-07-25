//
//  VehicleSubscriptionPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehicleSubscriptionPresenter {

    /// Invoked when view is loaded into memory.
    func viewDidLoad()

    /// Called when document value changes.
    func didChange(document: String)

    /// Called when vehicle plate number changes.
    func didChange(vehicle: String)

    /// Invoked when cancel button is tapped.
    func didTapCancel()

    /// Invoked when next button is pressed.
    func didTapNext()

}
