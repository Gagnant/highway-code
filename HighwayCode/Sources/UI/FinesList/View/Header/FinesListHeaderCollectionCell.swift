//
//  FinesListHeaderCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 22.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class FinesListHeaderCollectionCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    // MARK: - FinesListSectionHeaderView

    static let reuseIdentifier = String(describing: "FinesListHeaderCollectionCell")

    static var nib: UINib {
        let bundle = Bundle(for: FinesListHeaderCollectionCell.self)
        return UINib(nibName: "FinesListHeaderCollectionCell", bundle: bundle)
    }

    static func instantiate() -> FinesListHeaderCollectionCell {
        return nib.instantiate(withOwner: nil, options: nil).first as! FinesListHeaderCollectionCell
    }

    // MARK: -

    func configure(title: String) {
        titleLabel.text = title
    }

}
