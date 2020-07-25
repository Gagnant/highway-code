//
//  DecimalNumberFormatter.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 08.05.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class DecimalNumberFormatter: NumberFormatter {

    override func number(from string: String) -> NSNumber? {
        if !generatesDecimalNumbers {
            return super.number(from: string)
        }
        return decimal(from: string).map(NSDecimalNumber.init)
    }

    private func decimal(from string: String) -> Decimal? {
        let scanner = self.scanner(string: string)
        var negative = false
        if let characters = scanner._scanCharacters(from: CharacterSet(charactersIn: "-+")) {
            guard characters.count == 1 else {
                return nil
            }
            negative = characters == "-"
        }
        var mantissaString = ""
        while let characters = scanner._scanCharacters(from: .decimalDigits) {
            mantissaString.append(characters)
        }
        var exponent: Int32 = 0
        if let characters = scanner._scanCharacters(from: CharacterSet(charactersIn: decimalSeparator)) {
            guard characters.count == 1 else {
                return nil
            }
            while let characters = scanner._scanCharacters(from: .decimalDigits) {
                mantissaString.append(characters)
                exponent -= Int32(characters.count)
            }
        }
        if let characters = scanner._scanCharacters(from: CharacterSet(charactersIn: "E"))  {
            guard characters.count == 1 else {
                return nil
            }
            let exponentCharacters = CharacterSet(charactersIn: "+-").union(.alphanumerics)
            var exponentString = ""
            while let characters = scanner._scanCharacters(from: exponentCharacters) {
                exponentString.append(characters)
            }
            if !exponentString.isEmpty {
                if let scannedExponent = Int32(exponentString) {
                    exponent += scannedExponent
                } else {
                    return nil
                }
            }
        }
        mantissaString = String(mantissaString.enumerated().drop { element -> Bool in
            return element.element == "0" && element.offset < mantissaString.count - 1
        }.map { $0.element })
        let trimmedMantissaString = String(mantissaString.reversed().enumerated().drop { element -> Bool in
            return element.element == "0" && element.offset < mantissaString.count - 1
        }.reversed().map { $0.element })
        exponent += Int32(mantissaString.count - trimmedMantissaString.count)
        guard var number = Decimal(string: trimmedMantissaString),
              NSDecimalNumber(decimal: number).stringValue == trimmedMantissaString,
              scanner.isAtEnd else {
            return nil
        }
        if negative {
            number.negate()
        }
        exponent += Int32(number.exponent)
        guard (-128..<128).contains(exponent) else {
            return nil
        }
        number._exponent += exponent
        return number
    }

    private func scanner(string: String) -> Scanner {
        let scanner = Scanner(string: string)
        scanner.caseSensitive = false
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: " ")
        return scanner
    }

}
