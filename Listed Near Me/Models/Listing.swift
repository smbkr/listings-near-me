//
//  Listing.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

struct Listing {
    var location: Location
    var grade: Grade?
    var listedDate: String
    var name: String
    
    init(name: String, grade: Grade?, location: Location, listedDate: String) {
        self.name = name.localizedCapitalized
        self.grade = grade
        self.location = location
        self.listedDate = listedDate
    }
}
