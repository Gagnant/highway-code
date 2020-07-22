//
//  CameraViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import CoreLocation

struct CameraViewModel: Hashable {

    /// Camera name.
    let name: String

    /// Camera address name.
    let address: String

    /// Camera location.
    let location: CLLocationCoordinate2D

}
