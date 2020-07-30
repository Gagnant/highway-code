//
//  IVehicleFinesListInteractor.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehicleFinesListInteractor: IFinesListInteractor {

    /// Returns vehicle subscription.
    var subscription: VehicleSubscription? { get }

    /// Removes subscription.
    func remove(success: @escaping () -> Void, failure: @escaping () -> Void)

}
