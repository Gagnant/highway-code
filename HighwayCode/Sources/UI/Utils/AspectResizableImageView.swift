//
//  AspectResizableImageView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 09.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class AspectResizableImageView: UIImageView {

    override var image: UIImage? {
        didSet { didSetImage() }
    }

    // MARK: -

    private var aspectLayoutConstraint: NSLayoutConstraint?

    private func didSetImage() {
        updateAspectConstraint()
    }

    private func updateAspectConstraint() {
        aspectLayoutConstraint?.isActive = false
        aspectLayoutConstraint = nil
        guard let image = self.image else {
            return
        }
        let constraint = widthAnchor.constraint(
            equalTo: heightAnchor, multiplier: image.size.width / image.size.height, constant: 0.0
        )
        aspectLayoutConstraint = constraint
        constraint.isActive = true
    }

}
