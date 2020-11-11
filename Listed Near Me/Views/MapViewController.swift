//
//  MapViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 03/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    private let zoomMin = 500
    private let zoomMax = 6000 * 500
    private var mapView = MKMapView()
    private var currentLocation: CLLocation? {
        didSet {
            if mapViewRegionDidChangeFromUserInteraction() == false {
                guard let currentLocation = currentLocation else { return }
                mapView.centerOnLocation(currentLocation)
            }
        }
    }
    public var listings = [Listing]() {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(listings)
        }
    }
    public var visibleMapRect: MKMapRect {
        get {
            return mapView.visibleMapRect
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        mapView.showsTraffic = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion.England),
            animated: true
        )

        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: CLLocationDistance(zoomMin),
                maxCenterCoordinateDistance: CLLocationDistance(zoomMax)
            ),
            animated: true
        )
        
        if currentLocation == nil {
            let center = CLLocation(
                latitude: MKCoordinateRegion.England.center.latitude,
                longitude: MKCoordinateRegion.England.center.longitude
            )
            mapView.centerOnLocation(center, radiusMeters: Double(zoomMax))
        }
        
        mapView.register(
            ListingAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: ListingAnnotationViewReuseIdentifier
        )
        
        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard let parent = parent as? ViewController else { return }
        parent.refreshListings() // FIXME awful
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = mapView.subviews[0]
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: ListingAnnotationViewReuseIdentifier,
            for: annotation
        )
        return view
    }

}
