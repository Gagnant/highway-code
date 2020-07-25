//
//  VehiclesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehiclesListRouter: IVehiclesListRouter {

    weak var controller: UIViewController?

    func resolutions(subscriptionId: Int) {
//        let destination = FinesListBuilder.build(subscriptionId: subscriptionId)
//        controller?.navigationController?.pushViewController(destination, animated: true)
    }

    func subscription() {
        let destination = VehicleSubscriptionBuilder.build()
        controller?.present(destination, animated: true, completion: nil)
    }

}
