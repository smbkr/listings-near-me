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
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case location, grade, name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name).localizedCapitalized
        self.grade = try container.decode(Grade?.self, forKey: .grade)
        self.location = try container.decode(Location.self, forKey: .location)
    }
}
