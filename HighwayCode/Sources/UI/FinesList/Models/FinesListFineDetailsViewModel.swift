//
//  FinesListFineDetailsViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

struct FinesListFineDetailsViewModel: IFinesListElementViewModel, Equatable {

    /// Element identifier.
    let id: String

    /// Fine amount.
    let amount: Decimal

    /// Fine amount required to pay.
    let payAmount: Decimal

    /// Optional vehicle plate number.
    let vehicleNumber: String?

    /// The date of action which caused fine.
    let date: Date

    /// Optional main action.
    let mainAction: TaggedClosureBox<Void, Void>?

    /// Optional accessory action.
    let payAction: TaggedClosureBox<Void, Void>?

    // MARK: -

    func accept<V>(visitor: V) -> V.Result where V: IFinesListElementViewModelVisitor {
        return visitor.visit(viewModel: self)
    }

    var differenceIdentifier: String {
        return id
    }

}
