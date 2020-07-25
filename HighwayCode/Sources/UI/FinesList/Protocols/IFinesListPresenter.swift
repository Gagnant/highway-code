//
//  IFinesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFinesListPresenter {

    /// Invoked when view is loaded and ready for use.
    func viewDidLoad()

    /// Invoked when view is about to appear.
    func viewWillAppear()

    /// Invoked when view has disappeared.
    func viewDidDisappear()

    /// Invoke when update button is pressed.
    func didTapUpdate()

}
