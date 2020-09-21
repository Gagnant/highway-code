//
//  ResolutionMedia.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct ResolutionMedia: Decodable {

    enum ContentType: Int, Decodable {
        case image = 1, video = 2
    }

    /// Media type.
    let type: ContentType

    /// Media resource
    let url: URL

}
