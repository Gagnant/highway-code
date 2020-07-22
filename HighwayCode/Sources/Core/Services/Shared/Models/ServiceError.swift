//
//  ServiceError.swift
//  Cash Collection
//
//  Created by Andrew Visotskyy on 23.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct ServiceError: LocalizedError, Decodable {

    /// Error code.
    let code: Int

    /// Error description.
    let errorDescription: String?

    // MARK: - LocalizedError

    private enum CodingKeys: String, CodingKey {
        case code = "resultCode", errorDescription = "errorText"
    }

}
