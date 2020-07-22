//
//  Core.swift
//  PersonsSample
//
//  Created by Andrew Visotskyy on 18.06.2020.
//  Copyright © 2020 gagnant. All rights reserved.
//

import Foundation

class Core {

    /// Shared core instance.
    static var shared: Core!

    /// Configures shared instance.
    static func configure() {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let encoder = JSONEncoder()

        let httpConnector = HttpSessionConnector(
            session: URLSession.shared,
            baseURL: URL(string: "https://vfx-api.mvs.gov.ua/api/mobile/")!,
            decoder: AnyTopLevelDecoder(decoder)
        )

        let connectors = ConnectorManager(http: httpConnector)

        let camerasService = RemoteCamerasService(connectors: connectors)

        let resolutionsService = RemoteResolutionsService(connectors: connectors, encoder: encoder)

        shared = Core(camerasService: camerasService, resolutionsService: resolutionsService)
    }

    // MARK: -

    /// Cameras service.
    let camerasService: CamerasService

    /// Resolutions service.
    let resolutionsService: ResolutionsService

    init(camerasService: CamerasService, resolutionsService: ResolutionsService) {
        self.camerasService = camerasService
        self.resolutionsService = resolutionsService
    }

}




class HttpResource<Value: Decodable, Failure: Decodable & Error>: Resource {

    /// Connector to fetch resource from.
    let connector: HttpConnector

    /// Resource request.
    let request: Request

    // MARK: - Resource

    init(connector: HttpConnector, request: Request) {
        self.connector = connector
        self.request = request
        isLoading = false
        observations = [:]
    }

    /// Value.
    var value: Value?

    /// Error.
    var error: Error?

    /// Is loading.
    var isLoading: Bool

    private var observations: [ObjectIdentifier: () -> Void]

    func update() {
        guard !isLoading else {
            return
        }
        var task = connector.task(request: request, errorType: Failure.self, valueType: Value.self)
        task.onSuccess = { [weak self] value in
            self?.error = nil
            self?.value = value
            self?.isLoading = false
            self?.observations.values.forEach { $0() }
        }
        task.onFailure = { [weak self] error in
            self?.error = error
            self?.isLoading = false
            self?.observations.values.forEach { $0() }
        }
        isLoading = true
        task.resume()
        observations.values.forEach { $0() }
    }

    func attach(_ observer: AnyObject, observation: @escaping () -> Void) {
        let identifier = ObjectIdentifier(observer)
        guard observations[identifier] == nil else {
            NSLog("Observation for given observer is already registerd!")
            return
        }
        observations[identifier] = observation
    }

    func remove(_ observer: AnyObject) {
        let identifier = ObjectIdentifier(observer)
        observations[identifier] = nil
    }

    func didChanged() {
        observations.values.forEach { $0() }
    }

}






import CoreLocation








//

