//
//  DecimalNumberCoding.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class KeyedContainerDecimalDecodingProxy<K> where K: CodingKey {

    private let container: KeyedDecodingContainer<K>

    init(_ container: KeyedDecodingContainer<K>) {
        self.container = container
    }

    // MARK: -

    /// Locale used for number decoding.
    var locale: Locale = Locale(identifier: "en_US")

    func decodeNumber(forKey key: K) throws -> Decimal {
        let string = try container.decode(String.self, forKey: key)
        guard let decimal = numberFormatter.number(from: string)?.decimalValue else {
            throw decodingError(forKey: key)
        }
        return decimal
    }

    private func decodeNumberIfPresent(forKey key: K) throws -> Decimal? {
        guard let string = try container.decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        guard let decimal = numberFormatter.number(from: string)?.decimalValue else {
            throw decodingError(forKey: key)
        }
        return decimal
    }

    // MARK: -

    private var numberFormatter: DecimalNumberFormatter {
        let formatter = DecimalNumberFormatter()
        formatter.locale = locale
        formatter.generatesDecimalNumbers = true
        return formatter
    }

    private func decodingError(forKey key: K) -> Error {
        let debugDescription = "Value is not a valid decimal."
        return DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: debugDescription)
    }

}

class KeyedContainerDecimalEncodingProxy<K> where K: CodingKey {

    private var container: KeyedEncodingContainer<K>

    init(_ container: KeyedEncodingContainer<K>) {
        self.container = container
    }

    // MARK: -

    /// Locale used for number encoding.
    var locale: Locale = Locale(identifier: "en_US")

    func encode(_ number: Decimal, forKey key: K) throws {
        let numberString = NSDecimalNumber(decimal: number).description(withLocale: locale)
        try container.encode(numberString, forKey: key)
    }

}
