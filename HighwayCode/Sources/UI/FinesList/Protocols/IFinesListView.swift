//
//  IFinesListView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFinesListView: class {

    /// Updates view's content with given view model.
    func update(viewModel: FinesListViewModel)

}
