//
//  FinesListTooltipCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 23.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class FinesListTooltipCollectionCell: UICollectionViewCell, ReusableView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    // MARK: - FinesListTooltipCollectionCell

    static let reuseIdentifier = "FinesListTooltipCollectionCell"

    static var nib: UINib {
        let bundle = Bundle(for: FinesListTooltipCollectionCell.self)
        return UINib(nibName: "FinesListTooltipCollectionCell", bundle: bundle)
    }

    static func instantiate() -> FinesListTooltipCollectionCell {
        return nib.instantiate(withOwner: nil, options: nil).first as! FinesListTooltipCollectionCell
    }

    // MARK: -

    func configure(viewModel: FinesListTooltipViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

}
