//
//  Camera.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import CoreLocation

struct Camera: Hashable, Equatable {

    /// Camera name.
    let name: String

    /// Camera address name.
    let address: String

    /// Camera location.
    let location: CLLocationCoordinate2D

}

extension Camera: Decodable {

    private enum CodingKeys: String, CodingKey {
        case name, address, latitude, longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try CLLocationCoordinate2D(from: decoder)
        address = try container.decode(String.self, forKey: .address)
        name = try container.decode(String.self, forKey: .name)
    }

}
