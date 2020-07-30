//
//  FinesListActionViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct FinesListActionViewModel: IFinesListElementViewModel, Equatable {

    /// Identifier.
    let id: String

    /// Title.
    let title: String

    /// Defines if action is destructive.
    let isDestructive: Bool

    /// Handler.
    let handler: TaggedClosureBox<Void, Void>

    func accept<V>(visitor: V) -> V.Result where V: IFinesListElementViewModelVisitor {
        return visitor.visit(viewModel: self)
    }

    var differenceIdentifier: String {
        return id
    }

}
