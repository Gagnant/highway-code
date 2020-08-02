//
//  Core.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 18.06.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFunctions
import FirebaseAuth

class Core {

    /// Authentication serivce.
    let authentication: AuthenticationService

    /// Cameras service.
    let cameras: CamerasService

    /// Payments service.
    let payments: PaymentsService

    /// Resolutions service.
    let resolutions: ResolutionsService

    /// Creates core instance.
    init(authentication: AuthenticationService, cameras: CamerasService, payments: PaymentsService, resolutions: ResolutionsService) {
        self.authentication = authentication
        self.cameras = cameras
        self.payments = payments
        self.resolutions = resolutions
    }

    // MARK: - Shared

    /// Shared core instance.
    static var shared: Core!

    /// Configures a shared `Core`. This method should be called after the app
    /// is launched and before using `Core` services. This method should be
    /// called from the main thread.
    static func configure() {
        FirebaseApp.configure()
        let firebase = FirebaseApp.app()!
        let httpConnector = httpSessionConnector()
        let connectors = ConnectorManager(
            http: httpConnector,
            subscription: subscriptionConnector(firebase: firebase),
            callable: callableConnector(firebase: firebase)
        )
        let credentialsStorage = KeychainCredentialsStorage(service: "auth-credentials")
        let authentication = FirebaseAuthenticationService(firebase: firebase, callable: connectors.callable, credentialsStorage: credentialsStorage)
        httpConnector.accessTokenProvider = authentication
        let resolutions = RemoteResolutionsService(connectors: connectors)
        let core = Core(
            authentication: authentication,
            cameras: RemoteCamerasService(connectors: connectors),
            payments: RemotePaymentsService(connectors: connectors, resolutionProvider: resolutions),
            resolutions: resolutions
        )
        shared = core
    }

    private static func httpSessionConnector() -> HttpSessionConnector {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        let connector = HttpSessionConnector(
            session: URLSession.shared,
            baseURL: URL(string: "https://vfx-api.mvs.gov.ua/api/mobile/")!,
            decoder: AnyTopLevelDecoder(decoder),
            encoder: encoder
        )
        return connector
    }

    private static func subscriptionConnector(firebase: FirebaseApp) -> SubscriptionConnector {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return FirestoreConnector(firebase: firebase, decoder: decoder)
    }

    private static func callableConnector(firebase: FirebaseApp) -> CallableConnector {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        let functions = Functions.functions(region: "europe-west1")
        return CallableFunctionsConnector(functions: functions, decoder: decoder, encoder: encoder)
    }

}
