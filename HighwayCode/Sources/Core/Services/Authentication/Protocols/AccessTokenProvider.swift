//
//  AccessTokenProvider.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 31.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol AccessTokenProvider: class {

    /// Generates access token.
    func generateAccessToken(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) -> Cancellable

}
