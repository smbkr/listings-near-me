//
//  UIImage+imageWithLabel.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 09/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func imageWithLabel(_ label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
