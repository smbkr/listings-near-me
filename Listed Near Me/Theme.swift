//
//  LookAndFeel.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 25/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel

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

extension FloatingPanelController {
    func setAppearance() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = .black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        surfaceView.appearance = appearance
        surfaceView.contentPadding.top = 16
    }
}
