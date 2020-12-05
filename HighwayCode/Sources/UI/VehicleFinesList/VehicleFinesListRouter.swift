//
//  VehicleFinesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class VehicleFinesListRouter: FinesListRouter, IVehicleFinesListRouter {

    func back() {
        controller?.navigationController?.popViewController(animated: true)
    }

    func removal(confirmation: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let removeActionTitle = Localized.Screen.VehicleResolutions.removalApprove
        let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) { _ in confirmation() }
        let cancelActionTitle = Localized.Screen.VehicleResolutions.removalCancel
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        controller?.present(alert, animated: true, completion: nil)
    }

    func error() {
        let alert = UIAlertController(title: "", message: Localized.Error.Generic.message, preferredStyle: .alert)
        let actionTitle = Localized.Error.Generic.continue
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }

}
