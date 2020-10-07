//
//  Grade.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

enum Grade: String {
    case I = "I"
    case II = "II"
    case IIs = "II*"
}

extension Grade: CustomStringConvertible {
    var description: String {
        switch self {
            case .I: return "I"
            case .II: return "II"
            case .IIs: return "II*"
        }
    }
}
