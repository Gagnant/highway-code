//
//  RawDataContent.swift
//  transport
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct RawDataContent: RequestContent {

    let data: Data

    /// The media type to use for the content.
    let mediaType: String

    // MARK: - RequestContent

    var contentType: String {
        return mediaType
    }

}
