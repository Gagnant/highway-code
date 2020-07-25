//
//  FineDetailsVideoMediaCollectionCell.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import AVFoundation

class FineDetailsVideoMediaCollectionCell: UICollectionViewCell {

    @IBOutlet private var videoContainerView: UIView!
    @IBOutlet private var videoPlayerView: PlayerView!

    private var videoPlayerLooper: AVPlayerLooper?
    private var viewModel: FineDetailsViewModel.Media?

    // MARK: - FineDetailsImageMediaCollectionCell

    static let reuseIdentifier = String(describing: "FineDetailsVideoMediaCollectionCell")

    static var nib: UINib {
        let bundle = Bundle(for: FineDetailsVideoMediaCollectionCell.self)
        return UINib(nibName: "FineDetailsVideoMediaCollectionCell", bundle: bundle)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configurePlayerLayer()
        configureGesture()
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }

    func configure(viewModel: FineDetailsViewModel.Media) {
        assert(viewModel.type == .video)
        let playerItem = AVPlayerItem(url: viewModel.url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        videoPlayerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        videoPlayerView.player = queuePlayer
        queuePlayer.play()
    }

    // MARK: -

    @objc private func didTapContent() {
        viewModel?.action?()
    }

    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(gesture)
    }

    private func configurePlayerLayer() {
        videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
    }

}
