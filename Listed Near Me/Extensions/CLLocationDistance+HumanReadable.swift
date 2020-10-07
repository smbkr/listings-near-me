//
//  CLLocationDistance+HumanReadable.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 17/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func humanReadableString() -> String {
        if (self < 10) {
            return "\(self.rounded(toPlaces: 2)) m"
        }
        else if (self < 1000) {
            return "\(Int(self)) m"
        }
        else {
            let distanceInKm = self / 1000
            return "\(distanceInKm.rounded(toPlaces: 2)) km"
        }
    }
}
