//
//  IVehiclesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehiclesListRouter {

    /// Opens resolutions for given subscription id.
    func resolutions(subscriptionId: Int)

    /// Opens vehicle subscription screen.
    func subscription()

}
