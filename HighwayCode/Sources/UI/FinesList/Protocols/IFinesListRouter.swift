//
//  IFinesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFinesListRouter {

    /// Transitions to resolution details.
    func resolution(id: Int)

    /// Initiates pay flow.
    func payment(resolutionId: Int)

}
