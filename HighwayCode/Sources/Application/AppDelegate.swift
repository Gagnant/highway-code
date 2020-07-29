//
//  AppDelegate.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import Foundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let controller = UITabBarController()
        controller.viewControllers = [
            FinesListBuilder.build(), CamerasBuilder.build()
        ]
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.tintColor = #colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9843137255, alpha: 1)
        return window
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Core.configure()
        configureKeyboardManager()
        window?.makeKeyAndVisible()
        return true
    }

}

// MARK: -

import IQKeyboardManagerSwift

extension AppDelegate {

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

}

