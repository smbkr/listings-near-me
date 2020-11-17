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
    func zoomToFit(centeredOn center: CLLocationCoordinate2D) {
        var coordinates = [CLLocationCoordinate2D]()
        var mapRects: [MKMapRect] = []
        
        if let userLocationCoordinates = self.userLocation.location?.coordinate {
            coordinates.append(userLocationCoordinates)
        }
        coordinates.append(contentsOf: self.annotations.map { $0.coordinate })
        let mapPoints = coordinates.map { MKMapPoint($0) }
        mapRects.append(contentsOf: mapPoints.map {
            MKMapRect(origin: $0, size: MKMapSize())
        })
        
        let fittingRect = mapRects.reduce(MKMapRect.null) { (result, element) in
            return result.union(element)
        }
        
        let padding: CGFloat = 50
        let edgePadding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.setVisibleMapRect(self.mapRectThatFits(fittingRect, edgePadding: edgePadding), animated: true)
    }
    
    func centerOnLocation(
        _ location: CLLocation,
        radiusMeters: CLLocationDistance? = nil
    ) {
        if let radiusMeters = radiusMeters {
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: radiusMeters,
                longitudinalMeters: radiusMeters)
            setRegion(coordinateRegion, animated: true)
        } else {
            setCenter(location.coordinate, animated: true)
        }
    }
}
