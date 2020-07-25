//
//  FinesListTooltipViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct FinesListTooltipViewModel: IFinesListElementViewModel, Equatable {

    /// Element identifier.
    let id: String

    /// Title text.
    let title: String

    /// Description text.
    let description: String

    func accept<V>(visitor: V) -> V.Result where V: IFinesListElementViewModelVisitor {
        return visitor.visit(viewModel: self)
    }

    var differenceIdentifier: String {
        return id
    }

}
