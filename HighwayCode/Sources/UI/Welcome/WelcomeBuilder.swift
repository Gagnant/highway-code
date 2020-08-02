//
//  WelcomeBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class WelcomeBuilder {

    static func build(window: UIWindow) -> UIViewController {
        let router = WelcomeRouter(window: window)
        let controller = WelcomeViewController(
            router: router, authenticationService: Core.shared.authentication
        )
        router.controller = controller
        return controller
    }

}
