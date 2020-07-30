//
//  FinesListActionCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class FinesListActionCollectionCell: UICollectionViewCell {

    @IBOutlet private var actionButton: UIButton!
    private var viewModel: FinesListActionViewModel?

    // MARK: - FinesListActionCollectionCell

    static let reuseIdentifier = String(describing: "FinesListActionCollectionCell")

    static var nib: UINib {
        let bundle = Bundle(for: FinesListActionCollectionCell.self)
        return UINib(nibName: "FinesListActionCollectionCell", bundle: bundle)
    }

    static func instantiate() -> FinesListActionCollectionCell {
        return nib.instantiate(withOwner: nil, options: nil).first as! FinesListActionCollectionCell
    }

    // MARK: -

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }

    func configure(viewModel: FinesListActionViewModel) {
        actionButton.setTitle(viewModel.title, for: .normal)
        actionButton.backgroundColor = viewModel.isDestructive ? #colorLiteral(red: 1, green: 0.3882352941, blue: 0.2784313725, alpha: 1) : .systemBlue
        self.viewModel = viewModel
    }

    // MARK: -

    @IBAction private func didTapButton() {
        viewModel?.handler.closure(())
    }

}
