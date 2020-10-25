//
//  ListingAnnotationView.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 25/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

let ListingAnnotationViewReuseIdentifier = "listing"

class ListingAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if newValue is Listing {
                markerTintColor = Theme.ListingColor
                clusteringIdentifier = "listing"
            }
        }
    }
}
