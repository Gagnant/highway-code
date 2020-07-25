//
//  Scanner+Extensions.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 08.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

extension Scanner {

    /// Scans the string as long as characters from a given character set are
    /// encountered, accumulating characters into a string.
    ///
    /// - Parameter set: The set of characters to scan.
    /// - Returns: Contains the characters scanned.
    func _scanCharacters(from set: CharacterSet) -> String? {
        if #available(iOS 13.0, *) {
            return scanCharacters(from: set)
        }
        var characters: NSString?
        if scanCharacters(from: set, into: &characters) {
            return characters as String?
        }
        return nil
    }

}
