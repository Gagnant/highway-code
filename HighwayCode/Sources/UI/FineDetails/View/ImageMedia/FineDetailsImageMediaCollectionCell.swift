//
//  FineDetailsImageMediaCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import SDWebImage

class FineDetailsImageMediaCollectionCell: UICollectionViewCell {

    @IBOutlet private var mediaImageView: UIImageView!
    private var viewModel: FineDetailsViewModel.Media?

    // MARK: - FineDetailsImageMediaCollectionCell

    static let reuseIdentifier = String(describing: "FineDetailsImageMediaCollectionCell")

    static var nib: UINib {
        let bundle = Bundle(for: FineDetailsImageMediaCollectionCell.self)
        return UINib(nibName: "FineDetailsImageMediaCollectionCell", bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureGesture()
        configureImageView()
    }

    override func prepareForReuse() {
        mediaImageView.sd_cancelCurrentImageLoad()
        viewModel = nil
        super.prepareForReuse()
    }

    func configure(viewModel: FineDetailsViewModel.Media) {
        assert(viewModel.type == .image)
        mediaImageView.image = nil
        mediaImageView.sd_setImage(with: viewModel.url, completed: nil)
        self.viewModel = viewModel
    }

    // MARK: -

    @objc private func didTapContent() {
        viewModel?.action?.closure(())
    }

    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(gesture)
    }

    private func configureImageView() {
        mediaImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        mediaImageView.sd_imageTransition = .fade
    }

}
