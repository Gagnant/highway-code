//
//  AnyTopLevelDecoder.swift
//  Cash Collection
//
//  Created by Andrew Visotskyy on 21.04.2020.
//  Copyright © 2020 Andrew Vysotskyi. All rights reserved.
//

import Foundation

struct AnyTopLevelDecoder<Input>: TopLevelDecoder {

    private let box: _AnyTopLevelDecoderBase<Input>

    init<Decoder: TopLevelDecoder>(_ decoder: Decoder) where Decoder.Input == Input {
        box = _AnyTopLevelDecoderBox(decoder)
    }

    func decode<T>(_ type: T.Type, from input: Input) throws -> T where T : Decodable {
        return try box.decode(type, from: input)
    }

}

private class _AnyTopLevelDecoderBase<Input>: TopLevelDecoder {

    func decode<T>(_ type: T.Type, from: Input) throws -> T where T : Decodable {
        fatalError("Must override")
    }

}

private final class _AnyTopLevelDecoderBox<Decoder: TopLevelDecoder>: _AnyTopLevelDecoderBase<Decoder.Input> {

    private let decoder: Decoder

    init(_ decoder: Decoder) {
        self.decoder = decoder
    }

    override func decode<T>(_ type: T.Type, from input: Input) throws -> T where T : Decodable {
        return try decoder.decode(type, from: input)
    }

}
