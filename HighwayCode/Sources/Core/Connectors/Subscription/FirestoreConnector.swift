//
//  FirestoreConnector.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 20.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreConnector: SubscriptionConnector {

    private let firebase: FirebaseApp
    private let decoder: JSONDecoder
    private var subscriptions: [AnyHashable: SubscriptionConnectorSubscription]

    init(firebase: FirebaseApp, decoder: JSONDecoder) {
        self.firebase = firebase
        self.decoder = decoder
        subscriptions = [:]
    }

    // MARK: - SubscriptionConnector

    func subscribe<Result>(request: SubscriptionConnectorRequest<Result>, subscription: @escaping (Result) -> Void) -> AnyHashable where Result: Decodable {
        let subscription = FirestoreSubscription(firebase: firebase, request: request, decoder: decoder, subscription: subscription)
        let subscriptionIdentifier = ObjectIdentifier(subscription)
        subscriptions[subscriptionIdentifier] = subscription
        subscription.resume()
        return subscriptionIdentifier
    }

    func cancelSubscription(_ subscribtion: AnyHashable) {
        subscriptions.removeValue(forKey: subscribtion)?.cancel()
    }

}
