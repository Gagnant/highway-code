//
//  WelcomeRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class WelcomeRouter: IWelcomeRouter {

    weak var window: UIWindow?
    weak var controller: UIViewController?

    init(window: UIWindow) {
        self.window = window
    }

    func next() {
        guard let window = self.window else {
            NSLog("Window is missing!")
            return
        }
        let controller = UITabBarController()
        controller.viewControllers = [FinesListBuilder.build(), CamerasBuilder.build()]
        window.rootViewController = controller
        UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }

    func error() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("generic-error-message", comment: ""), preferredStyle: .alert)
        let actionTitle = NSLocalizedString("generic-error-continue", comment: "")
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }

}
