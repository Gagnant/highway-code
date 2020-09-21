//
//  CamerasViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct CamerasViewModel {

    /// Visible cameras.
    let cameras: [CameraViewModel]

    /// Location access.
    let locationAccess: LocationAccess

    /// Defines whether loading indicator should be visible.
    let isLoading: Bool

}

extension CamerasViewModel {

    /// Location access state.
    enum LocationAccess {

        /// User has not yet made a choice with regards to this application.
        case notDetermined

        /// This application is not authorized to use location services.
        case restricted

        /// User has explicitly denied access.
        case denied

        /// User has granted authorization to use their location.
        case allowed

        /// Informs that location services are disabled on the device.
        case disabled

    }

}
