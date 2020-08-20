//
//  FinesListFineDetailsCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 22.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListFineDetailsCollectionCell: UICollectionViewCell {

    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var reducedAmountLabel: UILabel!
    @IBOutlet private var vehicleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var accessoryButtonContainer: UIView!
    @IBOutlet private var accessoryButton: UIButton!

    private var viewModel: FinesListFineDetailsViewModel?

    // MARK: - FinesListFineDetailsCollectionCell

    static let reuseIdentifier = "FinesListFineDetailsCollectionCell"

    static var nib: UINib {
        let bundle = Bundle(for: FinesListFineDetailsCollectionCell.self)
        return UINib(nibName: "FinesListFineDetailsCollectionCell", bundle: bundle)
    }

    static func instantiate() -> FinesListFineDetailsCollectionCell {
        return nib.instantiate(withOwner: nil, options: nil).first as! FinesListFineDetailsCollectionCell
    }

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
        configureGesture()
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }

    // MARK: -

    func configure(viewModel: FinesListFineDetailsViewModel) {
        configureAmount(viewModel)
        vehicleLabel.text = viewModel.vehicleNumber ?? ""
        vehicleLabel.isHidden = viewModel.vehicleNumber == nil
        dateLabel.text = dateFormatter.string(from: viewModel.date)
        accessoryButtonContainer.isHidden = viewModel.payAction == nil
        self.viewModel = viewModel
    }

    // MARK: -

    @IBAction private func didTapAccessoryButton() {
        viewModel?.payAction?.closure(())
    }

    @objc private func didTapContent() {
        viewModel?.mainAction?.closure(())
    }

    // MARK: -

    private lazy var currencyNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.currencyCode = "UAH"
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy', 'HH':'ss"
        return dateFormatter
    }()

    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(gesture)
    }

    private func configureAmount(_ viewModel: FinesListFineDetailsViewModel) {
        let strikethroughAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strikethroughColor: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1),
        ]
        amountLabel.attributedText = NSAttributedString(
            string: currencyNumberFormatter.string(from: viewModel.amount as NSNumber) ?? "",
            attributes: strikethroughAttributes
        )
        amountLabel.isHidden = viewModel.amount == viewModel.payAmount
        reducedAmountLabel.text = currencyNumberFormatter.string(from: viewModel.payAmount as NSNumber)
    }

}
