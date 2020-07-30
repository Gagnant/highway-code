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
        NotificationCenter.default.removeObserver(self)
        super.prepareForReuse()
    }

    func configure(viewModel: FineDetailsViewModel.Media) {
        assert(viewModel.type == .video)
        let player = AVPlayer(url: viewModel.url)
        videoPlayerView.player = player
        NotificationCenter.default.addObserver(
            self, selector: #selector(restartPlayer), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem
        )
        player.play()
        self.viewModel = viewModel
    }

    // MARK: -

    @objc private func didTapContent() {
        viewModel?.action?.closure(())
    }

    @objc private func restartPlayer() {
        let player = videoPlayerView.player
        player?.seek(to: .zero)
        player?.play()
    }

    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
        contentView.addGestureRecognizer(gesture)
    }

    private func configurePlayerLayer() {
        videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
    }

}
