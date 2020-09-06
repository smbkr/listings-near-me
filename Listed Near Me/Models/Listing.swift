//
//  Listing.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

struct Listing: Codable {
    var name: String
    var location: Location
    var grade: Grade?
}
