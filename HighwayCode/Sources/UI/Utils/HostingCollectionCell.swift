//
//  HostingCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class HostingCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: "HostingCollectionCell")

    // MARK: -

    private weak var hostedController: UIViewController?

    func configure(hosted: UIViewController, parent: UIViewController) {
        host(controller: hosted, parent: parent)
    }

    override func prepareForReuse() {
        hostedController.map(self.remove)
        super.prepareForReuse()
    }

    // MARK: - Private

    private func host(controller hosted: UIViewController, parent: UIViewController) {
        parent.addChild(hosted)
        hosted.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hosted.view)
        let constraints = [
            hosted.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hosted.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hosted.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hosted.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        hosted.didMove(toParent: parent)
        self.hostedController = hosted
    }

    private func remove(controller hosted: UIViewController) {
        hosted.willMove(toParent: nil)
        hosted.view.removeFromSuperview()
        hosted.removeFromParent()
    }

}
