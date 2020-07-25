//
//  FirestoreSubscription.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 21.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class FirestoreSubscription<Result: Decodable>: SubscriptionConnectorSubscription {

    private let firebase: FirebaseApp
    private let request: SubscriptionConnectorRequest<Result>
    private let subscription: (Result) -> Void
    private let decoder: JSONDecoder

    private var listenerRegistration: ListenerRegistration?
    private var retryTimer: Timer?

    init(firebase: FirebaseApp, request: SubscriptionConnectorRequest<Result>, decoder: JSONDecoder, subscription: @escaping (Result) -> Void) {
        self.firebase = firebase
        self.request = request
        self.subscription = subscription
        self.decoder = decoder
    }

    func resume() {
        assert(listenerRegistration == nil)
        var registration: Query = Firestore.firestore(app: firebase).collection(request.path)
        if !request.isPublic {
            guard let user = Auth.auth(app: firebase).currentUser?.uid else {
                NSLog("Can't access private resource while not authenticated!")
                scheduleSubscriptionRetry()
                return
            }
            registration = registration.whereField("userId", isEqualTo: user)
        }
        listenerRegistration = registration.addSnapshotListener(includeMetadataChanges: true, listener: processCollectionSnapshot)
    }

    func cancel() {
        assert(listenerRegistration != nil)
        listenerRegistration?.remove()
        listenerRegistration = nil
        retryTimer?.invalidate()
    }

    // MARK: -

    private func processCollectionSnapshot(_ snapshot: QuerySnapshot?, error: Error?) {
        assert(listenerRegistration != nil)
        if let snapshot = snapshot {
            let object = snapshot.documents.compactMap(documentData(from:))
            processObject(object: object, metadata: snapshot.metadata)
        } else if let error = error {
            processError(error)
        } else {
            fatalError("Firestore SDK failure.")
        }
    }

    private func processObject(object: Any, metadata: SnapshotMetadata) {
        guard !metadata.hasPendingWrites && !(request.isCacheIgnored && metadata.isFromCache) else {
            NSLog("Subscription [\(request.path)] update ignored.")
            return
        }
        do {
            // Using `JSONSerialization` to serialize object, and `JSONDecoder`
            // to decode it back is inefficient but it requires less manually
            // written boilerplate code.
            // - TODO: Create custom `Decoder` to allow decoding objects from
            // Foundation objects.
            guard JSONSerialization.isValidJSONObject(object) else {
                throw NSError(domain: "firestore-connector.serialization", code: 1)
            }
            let data = try JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
            let result = try decoder.decode(Result.self, from: data)
            subscription(result)
        } catch {
            NSLog("Can't process subscription [\(request.path)] result: \(object)")
        }
    }

    private func processError(_ error: Error) {
        NSLog("Subscription [\(request.path)] error: \(error.localizedDescription). Will re-subscribe soon.")
        scheduleSubscriptionRetry()
    }

    private func scheduleSubscriptionRetry() {
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            NSLog("Retrying subscribing after failure.")
            self?.listenerRegistration = nil
            self?.resume()
        }
        retryTimer = timer
    }

    private func documentData(from snapshot: DocumentSnapshot) -> [String: Any]? {
        guard var data = snapshot.data() else {
            return nil
        }
        // Document id is not included in snapshot data, so
        // we are inserting it manually to simplify parsing.
        // According to an agreement with cloud, documents
        // will never have a property named id.
        data["id"] = snapshot.documentID
        return data
    }

}
