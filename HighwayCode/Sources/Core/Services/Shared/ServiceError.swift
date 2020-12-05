//
//  ServiceError.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 23.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct ServiceError: LocalizedError, Decodable {

    /// Error code.
    let code: Int

    /// Error description.
    var errorDescription: String? {
        return localizedDescriptions(for: code)
    }

    // MARK: -

    private enum CodingKeys: String, CodingKey {
        case code = "resultCode"
    }

    private func localizedDescriptions(for code: Int) -> String {
        let descriptionKeys = [
            107: Localized.Core.errorMissingVehicle,
            108: Localized.Core.errorDocumentNotRelatedToVehicle
        ]
        return descriptionKeys[code] ?? Localized.Core.errorClientInternal
    }

}
