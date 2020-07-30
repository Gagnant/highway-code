//
//  IAuthenticationService.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 25.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol AuthenticationService {

    /// Delegate.
    var delegate: MulticastDelegate<AuthenticationServiceDelegate> { get }

    /// Current user.
    var user: User? { get }

    /// Authenticates user.
    func authenticate(success: (() -> Void)?, failure: (() -> Void)?)

}

protocol AuthenticationServiceDelegate: class {

    /// Invoked when user changes.
    /// - Parameter service: service which triggered the change.
    func authenticationServiceUserDidChange(_ service: AuthenticationService)

}
