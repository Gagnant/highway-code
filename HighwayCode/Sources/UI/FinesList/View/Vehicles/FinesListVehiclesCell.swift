//
//  FinesListVehiclesCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.09.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListVehiclesCell: UICollectionViewCell {

    static let reuseIdentifier = "FinesListVehiclesCell"

    // MARK: -

    private weak var hostController: UIViewController?
    private weak var hostedController: UIViewController?

    func configure(with controller: UIViewController) {
        guard hostedController == nil else {
            return
        }
        hostController = controller
        let hosted = VehiclesListBuilder.build()
        host(viewController: hosted)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Invalidate hosted view controller.
    }

    deinit {
        hostedController.map(remove)
    }

    // MARK: - Private

    private func host(viewController hosted: UIViewController) {
        hostController?.addChild(hosted)
        hosted.view.translatesAutoresizingMaskIntoConstraints = true
        hosted.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hosted.view.frame = contentView.bounds
        contentView.addSubview(hosted.view)
        hosted.didMove(toParent: hostController)
        self.hostedController = hosted
    }

    private func remove(controller hosted: UIViewController) {
        hosted.willMove(toParent: nil)
        hosted.view.removeFromSuperview()
        hosted.removeFromParent()
    }

}
