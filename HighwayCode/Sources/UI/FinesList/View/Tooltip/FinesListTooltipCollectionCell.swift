//
//  FinesListTooltipCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 23.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class FinesListTooltipCollectionCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    // MARK: - FinesListTooltipCollectionCell

    static let reuseIdentifier = String(describing: "FinesListTooltipCollectionCell")

    static var nib: UINib {
        let bundle = Bundle(for: FinesListTooltipCollectionCell.self)
        return UINib(nibName: "FinesListTooltipCollectionCell", bundle: bundle)
    }

    static func instantiate(withOwner owner: Any? = nil) -> Self {
        return nib.instantiate(withOwner: owner, options: nil).first as! Self
    }

    // MARK: -

    func configure(viewModel: FinesListTooltipViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

}
