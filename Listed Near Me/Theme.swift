//
//  LookAndFeel.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 25/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    static let listingColor: UIColor = .orange
    static let buttonRadius = CGFloat(8)
}

extension Listing {
    var color: UIColor {
        get {
            switch grade {
            case .I:
                return .systemPurple
            case .IIs:
                return .systemOrange
            case .II:
                return .systemTeal
            default:
                return .systemGray2
            }
        }
    }
}
