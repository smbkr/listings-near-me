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
        return [
            Listing(
                name: "Foo",
                longLat: LongLat(long: 0, lat: 0),
                grade: .IIs
            ),
            Listing(
                name: "Bar",
                longLat: LongLat(long: 1, lat: 1)
            ),
            Listing(
                name: "Cathedral Church of St Paul",
                longLat: LongLat(long: -0.5, lat: 53),
                grade: .I
            )
        ]
    }
}
