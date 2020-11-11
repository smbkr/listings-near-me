//
//  Listing.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import MapKit

class Listing: NSObject {
    var title: String?
    var grade: Grade?
    var listedDate: String?
    var coordinate: CLLocationCoordinate2D
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    init(title: String, grade: Grade?, coordinate: CLLocationCoordinate2D, listedDate: String) {
        self.title = title.localizedCapitalized // TODO: better capitalisation, postcode aware, etc.
        self.grade = grade
        self.coordinate = coordinate
        self.listedDate = listedDate
    }
}

extension Listing: MKAnnotation {
    var subtitle: String? {
        get {
            if let grade = grade {
                return "Grade \(grade)"
            }
            return nil
        }
    }
}
