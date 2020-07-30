//
//  FinesListBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListBuilder {

    static func build() -> UIViewController {
        let router = FinesListRouter()
        let interactor = FinesListInteractor(
            resolutionsService: Core.shared.resolutionsService,
            paymentsService: Core.shared.paymentsService
        )
        let presenter = FinesListPresenter(router: router, interactor: interactor)
        let controller = FinesListViewController(
            presenter: presenter, vehiclesListControllerFactory: router
        )
        presenter.view = controller
        router.controller = controller
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = NSLocalizedString("screen-fines-list-tab-title", comment: "")
        navigation.tabBarItem.image = #imageLiteral(resourceName: "LawFile")
        return navigation
    }

}
