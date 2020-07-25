//
//  CamerasService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol CamerasService {

    /// Available cameras.
    var cameras: AnyResource<[Camera]> { get }

}
