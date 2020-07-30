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

    /// Shared core instance.
    static var shared: Core!

    /// Configures a shared `Core`. This method should be called after the app
    /// is launched and before using `Core` services. This method should be
    /// called from the main thread.
    static func configure() {
        FirebaseApp.configure()


        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        var httpConnector = HttpSessionConnector(
            session: URLSession.shared,
            baseURL: URL(string: "https://vfx-api.mvs.gov.ua/api/mobile/")!,
            decoder: AnyTopLevelDecoder(decoder),
            encoder: encoder
        )

        let firebase: (subscription: SubscriptionConnector, callable: CallableConnector) = {
            let firebase = FirebaseApp.app()!
            let functions = Functions.functions(region: "europe-west1")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            let connectors = (
                subscription: FirestoreConnector(firebase: firebase, decoder: decoder),
                callable: CallableFunctionsConnector(functions: functions, decoder: decoder, encoder: encoder)
            )
            return connectors
        }()

        let authService = FirebaseAuthenticationService(auth: Auth.auth(), callable: firebase.callable, credentialsStorage: KeychainCredentialsStorage(service: "auth-credentials"))

        httpConnector.accessTokenProvider = authService

        let connectors = ConnectorManager(http: httpConnector, subscription: firebase.subscription, callable: firebase.callable)

        let resolutionsService = RemoteResolutionsService(connectors: connectors, encoder: JSONEncoder())



        let core = Core(
            authService: authService,
            camerasService: RemoteCamerasService(connectors: connectors),
            paymentsService: RemotePaymentsService(connectors: connectors, resolutionProvider: resolutionsService),
            resolutionsService: resolutionsService
        )
        shared = core
    }

//    private static func createSharedConnectorManager() -> ConnectorManager {

//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .formatted(dateFormatter)
//
//        let httpConnector = HttpSessionConnector(
//            session: URLSession.shared,
//            baseURL: URL(string: "https://vfx-api.mvs.gov.ua/api/mobile/")!,
//            decoder: AnyTopLevelDecoder(decoder),
//            encoder: encoder
//        )
//
//        let firebase: (subscription: SubscriptionConnector, callable: CallableConnector) = {
//            let firebase = FirebaseApp.app()!
//            let functions = Functions.functions(region: "europe-west1")
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .secondsSince1970
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .secondsSince1970
//            let connectors = (
//                subscription: FirestoreConnector(firebase: firebase, decoder: decoder),
//                callable: CallableFunctionsConnector(functions: functions, decoder: decoder, encoder: encoder)
//            )
//            return connectors
//        }()
//
//        return .init(http: httpConnector, subscription: firebase.subscription, callable: firebase.callable)
//    }

    // MARK: -

    /// Authentication serivce.
    let authService: AuthenticationService

    /// Cameras service.
    let camerasService: CamerasService

    /// Payments service.
    let paymentsService: PaymentsService

    /// Resolutions service.
    let resolutionsService: ResolutionsService

    /// Creates core instance.
    init(
        authService: AuthenticationService,
        camerasService: CamerasService,
        paymentsService: PaymentsService,
        resolutionsService: ResolutionsService
    ) {
        self.authService = authService
        self.camerasService = camerasService
        self.paymentsService = paymentsService
        self.resolutionsService = resolutionsService
    }

}
