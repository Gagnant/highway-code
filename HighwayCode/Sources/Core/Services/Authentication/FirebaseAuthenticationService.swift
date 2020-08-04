//
//  FirebaseAuthenticationService.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 25.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import FirebaseAuth
import Firebase

class FirebaseAuthenticationService: AuthenticationService, AccessTokenProvider {

    private var credentialsStorage: CredentialsStorage!
    private let auth: Auth
    private let callable: CallableConnector

    init(firebase: FirebaseApp, callable: CallableConnector, credentialsStorage: CredentialsStorage) {
        self.auth = Auth.auth(app: firebase)
        self.callable = callable
        self.credentialsStorage = credentialsStorage
        delegate = MulticastDelegate()
        updateUser()
    }

    // MARK: -

    let delegate: MulticastDelegate<AuthenticationServiceDelegate>

    private(set) var user: User? {
        didSet { didSetUser(oldValue) }
    }

    var isAuthenticated: Bool {
        return user != nil
    }

    func authenticate(success: (() -> Void)?, failure: (() -> Void)?) {
        let completion: AuthDataResultCallback = { [weak self] result, error in
            if let user = result?.user {
                self?.user = User(id: user.uid)
                success?()
            } else {
                self?.user = nil
                failure?()
            }
        }
        auth.signInAnonymously(completion: completion)
    }

    // MARK: - Private

    private func didSetUser(_ oldValue: User?) {
        guard user != oldValue else {
            return
        }
        delegate.invoke { $0.authenticationServiceUserDidChange(self) }
    }

    private func updateUser() {
        user = auth.currentUser.flatMap { User(id: $0.uid) }
    }

    // MARK: - AccessTokenProvider

    func generateAccessToken(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) -> Cancellable {
        if let accessToken = storedAccessToken {
            success(accessToken)
            return BlockCancellable()
        }
        guard let user = self.user else {
            failure(NSError())
            return BlockCancellable()
        }
        return _generateAccessToken(userId: user.id, success: success, failure: failure)
    }

    private func _generateAccessToken(userId: String, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) -> Cancellable {
        var request = CallableFunctionRequest<VoidCodable, GenerateAccessTokenResponse>(
            method: "generateAccessToken", parameters: VoidCodable()
        )
        request.success = { [weak self] response in
            self?.credentialsStorage.credentials = Credentials(userId: userId, accessToken: response.accessToken)
            success(response.accessToken)
        }
        request.failure = { error in
            failure(error)
        }
        return callable.call(request: request)
    }

    private var storedAccessToken: String? {
        guard let user = self.user, let credentials = credentialsStorage.credentials else {
            return nil
        }
        return credentials.userId == user.id ? credentials.accessToken : nil
    }

}
