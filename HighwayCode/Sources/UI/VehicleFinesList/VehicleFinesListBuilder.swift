//
//  VehicleFinesListBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehicleFinesListBuilder {

    static func build(subscriptionId: Int) -> UIViewController {
        let router = VehicleFinesListRouter()
        let interactor = VehicleFinesListInteractor(
            resolutionsService: Core.shared.resolutionsService,
            paymentsService: Core.shared.paymentsService,
            subscriptionId: subscriptionId
        )
        let presenter = VehicleFinesListPresenter(
            router: router, interactor: interactor, subscriptionId: subscriptionId
        )
        let controller = FinesListViewController(presenter: presenter, vehiclesListControllerFactory: router)
        presenter.view = controller
        router.controller = controller
        return controller
    }

}
