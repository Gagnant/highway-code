//
//  AVPlayerItem+Extensions.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 18.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import AVFoundation

extension AVPlayerItem {

    /// Provides an array of AVAssetTracks of the asset that present media of the specified
    /// media type.
    ///
    /// Becomes callable without blocking when the key @"tracks" has been loaded
    ///
    /// - Parameter mediaType: The media type according to which AVPlayerItem filters its
    /// AVPlayerItemTrack.
    /// - Returns: An array of AVPlayerItemTrack; may be empty if no tracks of the specified media type are available.
    func tracks(withMediaType mediaType: AVMediaType) -> [AVPlayerItemTrack] {
        return tracks.filter { $0.assetTrack?.mediaType == mediaType }
    }

}
