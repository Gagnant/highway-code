//
//  IVehiclesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IVehiclesListPresenter {

    /// Invoked when view is loaded into memory.
    func viewDidLoad()

    /// Invoked when view is about to appear.
    func viewWillAppear()

    /// Invoked after view has disappeared.
    func viewDidDisappear()

    /// Invoked when add vehicles action is triggered.
    func didTapAddVehicles()

}
