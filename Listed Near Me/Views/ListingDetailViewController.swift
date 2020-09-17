//
//  DetailViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 14/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class ListingDetailViewController: UIViewController {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var gradeLabel: UILabel!
//    @IBOutlet weak var addedDateLabel: UILabel!
//    @IBOutlet weak var amendedDateLabel: UILabel!
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var coordinateLabel: UILabel!
    
    public var listing: Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        
        
        
        if let listing = listing {
            self.navigationItem.title = listing.name
//            titleLabel.text = listing.name
//
//            if let grade = listing.grade {
//                gradeLabel.text = grade.description
//            } else {
//                gradeLabel.text = "Ungraded"
//            }
//
//            let listingLocation = CLLocationCoordinate2D(latitude: listing.location.lat, longitude: listing.location.long)
//            let pin = MKPointAnnotation()
//            pin.title = listing.name
//            pin.coordinate = listingLocation
//            mapView.addAnnotation(pin)
//            let mapRegion = MKCoordinateRegion(center: listingLocation, latitudinalMeters: 250, longitudinalMeters: 250)
//            mapView.setRegion(mapRegion, animated: true)
            
            
        }
    }
}
