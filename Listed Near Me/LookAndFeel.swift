//
//  LookAndFeel.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 18/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

extension Listing {
    var color: UIColor {
        switch self.grade {
        case .I:
            return .purple
        case .II:
            return .orange
        case .IIs:
            return .green
        default:
            return .darkGray
        }
    }
}
