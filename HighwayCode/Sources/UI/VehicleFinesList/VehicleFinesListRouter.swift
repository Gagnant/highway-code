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
        let removeActionTitle = NSLocalizedString("vehicle-resolutions-removal-approve", comment: "")
        let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) { _ in confirmation() }
        let cancelActionTitle = NSLocalizedString("vehicle-resolutions-removal-cancel", comment: "")
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        controller?.present(alert, animated: true, completion: nil)
    }

    func error() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("generic-error-message", comment: ""), preferredStyle: .alert)
        let actionTitle = NSLocalizedString("generic-error-continue", comment: "")
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }

}
