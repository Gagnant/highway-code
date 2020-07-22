//
//  RemoteCamerasService.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

class RemoteCamerasService: CamerasService {

    private let connectors: ConnectorManager

    init(connectors: ConnectorManager) {
        self.connectors = connectors
    }

    // MARK: - CamerasService

    private(set) lazy var cameras: AnyResource<Cameras> = {
        let request = Request(method: "GET", path: "cameras")
        let resource = HttpResource<Cameras, ServiceError>(connector: connectors.http, request: request)
        return AnyResource(resource)
    }()

}
