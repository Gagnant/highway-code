//
//  StringContent.swift
//  transport
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct StringContent: RequestContent {

    /// The content used to initialize the StringContent.
    let string: String

    /// The media type to use for the content.
    let mediaType: String

    init(_ string: String, mediaType: String = "text/plain") {
        self.string = string
        self.mediaType = mediaType
    }

    // MARK: - RequestContent

    var data: Data {
        return Data(string.utf8)
    }

    var contentType: String {
        return "\(mediaType); charset=UTF-8"
    }

}
