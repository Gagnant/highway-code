//
//  VehicleSubscriptionRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehicleSubscriptionRouter {

    /// Proceeds to next screen.
    func next()

    /// Cancels subscription.
    func dismiss()

    /// Displays error message.
    func error(message: String)

}
