//
//  CoreError.swift
//  Cash Collection
//
//  Created by Andrew Visotskyy on 23.04.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

protocol CoreError: LocalizedError where Code.RawValue == Int {

    /// Error code.
    associatedtype Code: RawRepresentable

    /// Error code value.
    var code: Code { get }

    /// Creates instance of erorr with given parameters.
    /// - Parameters:
    ///   - code: error code.
    ///   - description: error description.
    init(code: Code, errorDescription: String?)

}
