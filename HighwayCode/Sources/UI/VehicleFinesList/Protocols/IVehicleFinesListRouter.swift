//
//  IVehicleFinesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehicleFinesListRouter: IFinesListRouter {

    /// Returns back.
    func back()

    /// Shows removal confirmation.
    func removal(confirmation: @escaping () -> Void)

    /// Shows generic error.
    func error()

}
