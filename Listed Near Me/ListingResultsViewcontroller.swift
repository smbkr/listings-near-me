//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class ListingResultsViewcontroller: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let showDetailView = "showDetailView"
    private var listings: [Listing] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let api = ListingsAPI()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation? {
        didSet {
            // TODO Extract to a method
            self.loadListingsForLocation(currentLocation!)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation!) { (placemark, error) in
                guard error == nil else {
                    print(error!) // TODO
                    return
                }
                let currentPlacemark = placemark?.first
                if let locality = currentPlacemark?.subLocality {
                    self.navigationItem.title = "Listings Near \(locality)"
               }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func refreshLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func loadListingsForLocation(_ location: CLLocation) {
        self.api.getNear(location) { (result) in
            switch result {
            case .success(let listings):
                self.listings = listings
            case .failure(let error):
                print(error) // TODO: Better error handling
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showDetailView,
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
            else {
                return
            }
        let listing = listings[indexPath.row]
        detailViewController.listing = listing
    }
    
}

extension ListingResultsViewcontroller: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = self.listings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listing") as! ListingTableViewCell
        cell.updateListing(listing)
        
        if let currentLocation = self.currentLocation {
            let listingLocation = CLLocation(latitude: listing.location.lat, longitude: listing.location.long)
            let distance = listingLocation.distance(from: currentLocation)
            cell.updateDistance(distance)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showDetailView, sender: tableView.cellForRow(at: indexPath))
    }
    
}

extension ListingResultsViewcontroller: CLLocationManagerDelegate {
    
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
        
            self.currentLocation = location
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error: \(error)")
        }
        
}
