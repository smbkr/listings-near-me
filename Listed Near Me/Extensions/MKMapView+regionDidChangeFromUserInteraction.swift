//
//  MKMapView+regionDidChangeFromUserInteraction.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 15/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func regionDidChangeFromUserInteraction() -> Bool {
        let view = self.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if (
                    recognizer.state == UIGestureRecognizer.State.began ||
                        recognizer.state == UIGestureRecognizer.State.ended
                ) {
                    return true
                }
            }
        }
        return false
    }
}
