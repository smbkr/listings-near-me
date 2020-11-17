//
//  ListingAnnotationView.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 25/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

let defaultPointSize: Double = 8
let selectedMultiplier = 1.4
let ListingAnnotationViewReuseIdentifier = "listing"

class ListingAnnotationView: MKAnnotationView {
    let pointMarker = UIView(frame: CGRect(x: 0, y: 0, width: defaultPointSize, height: defaultPointSize))
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let listing = annotation as? Listing else { return }
        displayPriority = listing.displayPriority
        canShowCallout = true
        
        pointMarker.backgroundColor = listing.color
        pointMarker.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        pointMarker.layer.borderWidth = 2
        pointMarker.cornerRadius = CGFloat(defaultPointSize)
        addSubview(pointMarker)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            let newSize = Double(pointMarker.frame.width) * selectedMultiplier
            pointMarker.frame = CGRect(x: 0, y: 0, width: newSize, height: newSize)
        }
    }
}
