//
//  Listing.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

struct Listing: Codable {
    var location: Location
    var grade: Grade?
    private var _name: String
    var name: String {
        return _name.localizedCapitalized
    }
    
    private enum CodingKeys: String, CodingKey {
        case location, grade, _name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._name = try container.decode(String.self, forKey: ._name).localizedCapitalized
        self.grade = try container.decode(Grade?.self, forKey: .grade)
        self.location = try container.decode(Location.self, forKey: .location)
    }
    
    init(name: String, grade: Grade?, location: Location) {
        self._name = name
        self.grade = grade
        self.location = location
    }
}
