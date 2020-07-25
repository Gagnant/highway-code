//
//  VehiclesListElementViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import DifferenceKit

struct VehiclesListElementViewModel {

    /// Vehicle plate value.
    let plate: String

    /// Vehicle document.
    let document: String

    /// Interaction handler.
    let action: (() -> Void)?

}

extension VehiclesListElementViewModel: Differentiable {

    var differenceIdentifier: String {
        return plate + document
    }

    func isContentEqual(to source: VehiclesListElementViewModel) -> Bool {
        return plate == source.plate && document == source.document
    }

}
