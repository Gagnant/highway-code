//
//  IFineDetailsPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFineDetailsPresenter {

    /// Invoked when view is loaded into memory.
    func viewDidLoad()

    /// Invoked when view is about to appear.
    func viewWillAppear()

    /// Invoked when view disappears.
    func viewDidDisappear()

    /// Invoked when update is tapped.
    func didTapUpdate()

    /// Invoked when pay is tapped.
    func didTapPay()

}
