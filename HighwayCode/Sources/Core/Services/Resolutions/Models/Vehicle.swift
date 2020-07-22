//
//  Vehicle.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct Vehicle: Decodable, Hashable {

    /// Vehicle plate number.
    let plate: String

    /// Vehicle brand.
    let brand: String

    /// Vehicle model.
    let model: String?

    // MARK: - Decodable

    private enum CodingKeys: String, CodingKey {
        case plate = "vehiclePlate", brand = "vehicleBrand", model = "vehicleModel"
    }

}
