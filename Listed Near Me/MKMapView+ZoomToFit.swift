//
//  MKMapView+ZoomToFit.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 20/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import MapKit

extension MKMapView
{
    func fitAnnotationsAndUserLocation() {
        // TODO: Set minimum zoom level https://stackoverflow.com/questions/8465149/mkmaprect-zooms-too-much
        let padding: CGFloat = 50
        var coordinates = [CLLocationCoordinate2D]()
        
        if let userLocationCoordinates = self.userLocation.location?.coordinate {
            coordinates.append(userLocationCoordinates)
        }
        
        coordinates.append(contentsOf: self.annotations.map { $0.coordinate })
        
        let mapPoints = coordinates.map { MKMapPoint($0) }
        let mapRects = mapPoints.map { MKMapRect(origin: $0, size: MKMapSize(width: 0, height: 0)) }
        let fittingRect = mapRects.reduce(MKMapRect.null) { (result, element) in
            return result.union(element)
        }
        
        let edgePadding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.setVisibleMapRect(self.mapRectThatFits(fittingRect, edgePadding: edgePadding), animated: true)
    }
}
