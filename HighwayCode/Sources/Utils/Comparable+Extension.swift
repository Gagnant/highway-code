//
//  Comparable+Extension.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 01.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

/// Returns the input value clamped to the lower and upper limits.
func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
