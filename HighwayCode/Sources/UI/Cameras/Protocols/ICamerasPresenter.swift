//
//  ICamerasPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol ICamerasPresenter {

    /// Invoked when view is about to appear.
    func viewWillAppear()

    /// Invoked when view has disappeared from screen.
    func viewDidDisappear()

    /// Invoked when refresh button is pressed.
    func didTapRefreshButton()

}
