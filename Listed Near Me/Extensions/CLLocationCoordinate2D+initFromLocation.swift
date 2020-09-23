//
//  File.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 22/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    init(from location: Location) {
        self.init(latitude: location.lat, longitude: location.long)
    }
}
