//
//  VehicleSubscriptionRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehicleSubscriptionRouter: IVehicleSubscriptionRouter {

    weak var controller: UIViewController?

    func next() {
        controller?.navigationController?.dismiss(animated: true, completion: nil)
    }

    func dismiss() {
        controller?.navigationController?.dismiss(animated: true, completion: nil)
    }

    func error(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Localized.Error.Generic.continue, style: .default, handler: nil)
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }

}
