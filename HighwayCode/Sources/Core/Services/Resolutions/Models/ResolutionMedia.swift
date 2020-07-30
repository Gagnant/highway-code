//
//  ResolutionMedia.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct ResolutionMedia: Decodable, Equatable {

    enum ContentType: Int, Decodable {
        case image = 1, video = 2
    }

    /// Resolution identifier.
    var id: String {
        return url.absoluteString
    }

    /// Media type.
    let type: ContentType

    /// Media resource
    let url: URL

}
