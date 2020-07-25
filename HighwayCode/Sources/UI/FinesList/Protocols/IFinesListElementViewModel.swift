//
//  IFinesListElementViewModel.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import DifferenceKit

protocol IFinesListElementViewModel: Differentiable {

    /// Accepts given visitor and forwards self to it.
    func accept<V: IFinesListElementViewModelVisitor>(visitor: V) -> V.Result

}
