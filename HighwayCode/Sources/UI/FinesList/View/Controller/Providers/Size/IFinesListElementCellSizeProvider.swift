//
//  IFinesListElementCellSizeProvider.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 29.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import CoreGraphics

protocol IFinesListElementCellSizeProvider {

    /// Returns size for given element layout.
    func size(for element: AnyFinesListElementViewModel) -> CGSize

}
