//
//  VehiclesListElementCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class VehiclesListElementCollectionCell: UICollectionViewCell {

    @IBOutlet private var plateNumberLabel: UILabel!
    @IBOutlet private var documentLabel: UILabel!

    private var viewModel: VehiclesListElementViewModel?

    // MARK: - FinesListFineDetailsCollectionCell

    static let reuseIdentifier = "VehiclesListElementCollectionCell"

    static var nib: UINib {
        let bundle = Bundle(for: VehiclesListElementCollectionCell.self)
        return UINib(nibName: "VehiclesListElementCollectionCell", bundle: bundle)
    }

    func configure(viewModel: VehiclesListElementViewModel) {
        plateNumberLabel.text = viewModel.plate
        documentLabel.text = viewModel.document
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureGesture()
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }

    // MARK: -

    @objc private func didTapContent() {
        viewModel?.action?()
    }

    // MARK: -

    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(gesture)
    }

}
