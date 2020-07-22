//
//  VehicleSubscriptionBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehicleSubscriptionBuilder {

    private init() {
        // NOP
    }

    static func build() -> UIViewController {
        let router = VehicleSubscriptionRouter()
        let presenter = VehicleSubscriptionPresenter(
            router: router, resolutions: Core.shared.resolutionsService
        )
        let controller = VehicleSubscriptionViewController(
            presenter: presenter, isSkipAvailable: false
        )
        presenter.view = controller
        router.controller = controller
        let navigation = UINavigationController(rootViewController: controller)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }

}