//
//  ResolutionProvider.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

protocol ResolutionProvider: class {

    /// Returns resolution for given id.
    func resolution(for id: Int) -> Resolution?

}
