//
//  HostingCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class HostingCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "HostingCollectionCell"

    // MARK: -

    private weak var hostedController: UIViewController?

    func configure(hosted: UIViewController, parent: UIViewController) {
        host(controller: hosted, parent: parent)
    }

    override func prepareForReuse() {
        hostedController.map(self.remove)
        hostedController = nil
        super.prepareForReuse()
    }

    // MARK: - Private

    private func host(controller hosted: UIViewController, parent: UIViewController) {
        parent.addChild(hosted)
        hosted.view.translatesAutoresizingMaskIntoConstraints = true
        hosted.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hosted.view.frame = contentView.bounds
        contentView.addSubview(hosted.view)
        hosted.didMove(toParent: parent)
        self.hostedController = hosted
    }

    private func remove(controller hosted: UIViewController) {
        hosted.willMove(toParent: nil)
        hosted.view.removeFromSuperview()
        hosted.removeFromParent()
    }

}
