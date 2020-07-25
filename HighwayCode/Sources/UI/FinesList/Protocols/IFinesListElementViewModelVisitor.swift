//
//  IFinesListElementViewModelVisitor.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFinesListElementViewModelVisitor {

    associatedtype Result

    /// Visits vehicle view model.
    func visit(viewModel: FinesListVehiclesViewModel) -> Result

    /// Visits fine details view model.
    func visit(viewModel: FinesListFineDetailsViewModel) -> Result

    /// Visits tooltip view model.
    func visit(viewModel: FinesListTooltipViewModel) -> Result

    /// Visits tooltip view model.
    func visit(viewModel: FinesListHeaderViewModel) -> Result

}
