//
//  RequestContent.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

protocol RequestContent {

    /// Request data.
    var data: Data { get }

    // MIME content type.
    var contentType: String { get }

}
