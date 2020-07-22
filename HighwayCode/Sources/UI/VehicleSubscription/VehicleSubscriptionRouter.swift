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
        // TODO: Do something
    }

    func dismiss() {
        // TODO: Do something
    }

    func error(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("alert-error-continue", comment: "")
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }

}
