//
//  VehiclesListBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehiclesListBuilder {

    static func build() -> UIViewController {
        let router = VehiclesListRouter()
        let presenter = VehiclesListPresenter(
            resolutionsService: Core.shared.resolutionsService, router: router
        )
        let controller = VehiclesListViewController(presenter: presenter)
        presenter.view = controller
        router.controller = controller
        return controller
    }

}
