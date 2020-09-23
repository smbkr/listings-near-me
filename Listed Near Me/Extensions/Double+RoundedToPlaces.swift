//
//  Double+RoundedToPlaces.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 17/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to n decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
