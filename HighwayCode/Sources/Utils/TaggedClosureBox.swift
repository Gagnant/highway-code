//
//  TaggedClosureBox.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 29.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct TaggedClosureBox<I, O>: Equatable, Hashable {

    /// Closure associated identifier.
    let id: String

    /// Boxed closure.
    let closure: (I) -> O

    init(id: String = UUID().uuidString, closure: @escaping (I) -> O) {
        self.id = id
        self.closure = closure
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TaggedClosureBox, rhs: TaggedClosureBox) -> Bool {
        return lhs.id == rhs.id
    }

}
