//
//  CameraAnnotation.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import CoreLocation
import MapKit.MKAnnotation

class CameraAnnotation: NSObject, MKAnnotation {

    /// Camera view mdoel.
    let camera: CameraViewModel

    init(camera: CameraViewModel) {
        self.camera = camera
    }

    var title: String? {
        return camera.name
    }

    var subtitle: String? {
        return camera.address
    }

    var coordinate: CLLocationCoordinate2D {
        return camera.location
    }

}
