//
//  FirebaseAuthenticationService.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 25.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import FirebaseAuth
import Firebase

class FirebaseAuthenticationService: AuthenticationService {

    private let firebaseAuth: Auth

    init(firebase: FirebaseApp) {
        firebaseAuth = Auth.auth(app: firebase)
        delegate = MulticastDelegate()
    }

    // MARK: -

    let delegate: MulticastDelegate<AuthenticationServiceDelegate>

    private(set) var user: User? {
        didSet { didSetUser(oldValue) }
    }

    func authenticate(success: (() -> Void)?, failure: (() -> Void)?) {
        firebaseAuth.signInAnonymously { [weak self] result, error in
            self?.user = result.flatMap {
                User(id: $0.user.uid)
            }
            if result != nil {
                success?()
                return
            }
            failure?()
        }
    }

    // MARK: - Private

    private func didSetUser(_ oldValue: User?) {
        guard user != oldValue else {
            return
        }
        delegate.invoke { $0.authenticationServiceUserDidChange(self) }
    }

}
