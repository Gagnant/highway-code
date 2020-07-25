//
//  TopLevelDecoder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.04.2020.
//  Copyright © 2020 Andrew Vysotskyi. All rights reserved.
//

import Foundation

/// A type that defines methods for decoding.
protocol TopLevelDecoder {

    associatedtype Input

    /// Decodes an instance of the indicated type.
    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T: Decodable

}

extension JSONDecoder: TopLevelDecoder { }
