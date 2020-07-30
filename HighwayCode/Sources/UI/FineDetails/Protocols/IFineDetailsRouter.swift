//
//  IFineDetailsRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol IFineDetailsRouter {

    /// Initiates pay flow.
    func payment(resolutionId: Int)

    /// Shows media for given resolution.
    func media(resolutionId: Int, mediaId: String)

}
