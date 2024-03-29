//
//  UIButton+cornerRadius.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 20/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import MapKit

@objc extension MKMapView {
    dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
