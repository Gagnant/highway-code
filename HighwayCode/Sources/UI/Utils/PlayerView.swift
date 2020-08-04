//
//  PlayerView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {

    /// Determines whether aspect constraint should be updated automatically
    /// based on current video track size.
    @IBInspectable var isAspectTrackingEnabled: Bool = false

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        registerObservations()
    }

    // MARK: -

    var player: AVPlayer? {
        get { return playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // MARK: -

    private var currentAssetObservation: NSKeyValueObservation?
    private var aspectLayoutConstraint: NSLayoutConstraint?

    private func registerObservations() {
        guard isAspectTrackingEnabled else {
            return
        }
        let options: NSKeyValueObservingOptions = [.new, .old, .initial]
        let observation = playerLayer.observe(\.player?.currentItem?.asset.tracks, options: options) { [weak self] (_, _) in
            self?.updateAspectConstraint()
        }
        self.currentAssetObservation = observation
    }

    private func updateAspectConstraint() {
        aspectLayoutConstraint?.isActive = false
        aspectLayoutConstraint = nil
        guard isAspectTrackingEnabled,
              let asset = player?.currentItem?.asset,
              asset.statusOfValue(forKey: "tracks", error: nil) == .loaded,
              let track = asset.tracks(withMediaType: .video).first else {
            return
        }
        let trackSize = track.naturalSize.applying(track.preferredTransform)
        let constraint = widthAnchor.constraint(
            equalTo: heightAnchor, multiplier: trackSize.width / trackSize.height, constant: 0.0
        )
        aspectLayoutConstraint = constraint
        constraint.isActive = true
    }

}
