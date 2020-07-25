//
//  IVehiclesListView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehiclesListView: class {

    /// Updates view with given view model.
    func update(viewModel: VehiclesListViewModel)

}
