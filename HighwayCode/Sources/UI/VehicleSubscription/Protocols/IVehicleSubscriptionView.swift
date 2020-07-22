//
//  VehicleSubscriptionView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehicleSubscriptionView: class {

    /// Updates view with given view model.
    func update(viewModel: VehicleSubscriptionViewModel)

    /// Changes view loading state.
    func setLoading(_ isLoading: Bool)

}
