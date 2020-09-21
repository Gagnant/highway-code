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
            resolutionsService: Core.shared.resolutions,
            paymentsService: Core.shared.payments,
            subscriptionId: subscriptionId
        )
        let presenter = VehicleFinesListPresenter(
            router: router, interactor: interactor, subscriptionId: subscriptionId
        )
        let cellProvider = FinesListCellProvider()
        let controller = FinesListViewController(presenter: presenter, cellProvider: cellProvider)
        presenter.view = controller
        router.controller = controller
        return controller
    }

}
