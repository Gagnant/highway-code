//
//  IFineDetailsView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFineDetailsView: class {

    /// Updates view with given view model.
    func update(with viewModel: FineDetailsViewModel)

    /// Changes loading state.
    func setLoading(_ isLoading: Bool)

}
