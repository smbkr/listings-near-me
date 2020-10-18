//
//  SqliteConstants.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 18/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
