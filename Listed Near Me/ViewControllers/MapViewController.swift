//
//  MapViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 08/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let api = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func refreshListings(_ updatedListings: [Listing]) {
        mapView.removeAnnotations(mapView.annotations)
        for listing in updatedListings {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: listing.location.lat, longitude: listing.location.long
            )
            annotation.title = listing.name
            if let grade = listing.grade {
                annotation.subtitle = "Grade \(grade)"
            }
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("Something is wrong with the location") // TODO: Better error handling
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        self.api.getNear(location) { (result) in
             switch result {
                 case .success(let listings):
                     DispatchQueue.main.async {
                        self.refreshListings(listings)
                     }
                 case .failure(let error):
                     print(error) // TODO: Better error handling
             }
         }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
}
