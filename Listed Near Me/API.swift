//
//  API.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

class API {
    func getAll() -> [Listing] {
        let stubListing = Listing(
            name: "Foo",
            longLat: LongLat(long: 0, lat:0),
            grade: .II
        )
        return [stubListing]
    }
}
