//
//  FinesListHeaderViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct FinesListHeaderViewModel: IFinesListElementViewModel, Equatable {

    /// Element identifier.
    let id: String

    /// Section name.
    let name: String

    func accept<V>(visitor: V) -> V.Result where V: IFinesListElementViewModelVisitor {
        return visitor.visit(viewModel: self)
    }

    var differenceIdentifier: String {
        return id
    }

}
