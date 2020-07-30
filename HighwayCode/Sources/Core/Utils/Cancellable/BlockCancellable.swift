//
//  BlockCancellable.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 31.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct BlockCancellable: Cancellable {

    /// Cancellation block.
    var cancelled: (() -> Void)?

    func cancel() {
        cancelled?()
    }

}
