//
//  VehiclesListViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct VehiclesListViewModel {

    /// Vehicles.
    let vehicles: [VehiclesListElementViewModel]

    /// Defines if loading indicator should be visible.
    let isLoading: Bool

    /// Determines if missing content is hidden.
    let isContentMissing: Bool

}
