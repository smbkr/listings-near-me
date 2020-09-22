//
//  DetailViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 14/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    public var listing: Listing?
    public var distance: CLLocationDistance?
    private var listingLocation: CLLocationCoordinate2D?
    private let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance(250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.mapView?.delegate = self
    }
    
    private func configureView() {
        guard let listing = listing, let distance = distance else { return }
        titleLabel.text = listing.name
        
        if let grade = listing.grade {
            gradeLabel.text = grade.description
        } else {
            gradeLabel.text = "Ungraded"
        }
        
        listingLocation = CLLocationCoordinate2D(from: listing.location)
        guard let listingLocation = listingLocation else { return }
        
        let pin = MKPointAnnotation()
        pin.title = listing.name
        pin.coordinate = listingLocation
        mapView.addAnnotation(pin)
        
        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.zoomToFit(centeredOn: listingLocation)
        
        coordinateLabel.text = "\(listingLocation.latitude), \(listingLocation.longitude)"
        distanceLabel.text = distance.humanReadableString()
    }
}

extension DetailTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let listingLocation = listingLocation else { return }
        mapView.zoomToFit(centeredOn: listingLocation)
    }
}
