//
//  ResolutionMediaVideoViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import AVFoundation

class ResolutionMediaVideoViewController: ResolutionMediaContentViewController, UIScrollViewDelegate {

    @IBOutlet private var contentPlayerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(media.type == .video)
        configureVideoView()
        resumeVideo()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentPlayerView
    }

    // MARK: -

    private func configureVideoView() {
        contentPlayerView.playerLayer.videoGravity = .resizeAspect
    }

    private func resumeVideo() {
        let player = AVPlayer(url: media.url)
        contentPlayerView.player = player
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self, selector: #selector(restartPlayer), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem
        )
        player.play()
    }

    @objc private func restartPlayer() {
        let player = contentPlayerView.player
        player?.seek(to: .zero)
        player?.play()
    }

}
