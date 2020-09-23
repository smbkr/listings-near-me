//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class ListingResultsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let showDetailViewSegue = "showDetailView"
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
            currentLocationDidChange()
        }
    }
    private var localityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        refreshLocation(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func refreshLocation(_ sender: Any?) {
        listings = []
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func getListingsForLocation(_ location: CLLocation) {
        showActivityIndicator()
        self.api.getNear(location) { (result) in
            switch result {
            case .success(let listings):
                self.listings = listings
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            case .failure(let error):
                print(error) // TODO: Better error handling
            }
        }
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = "Loading"
        
        let size = CGFloat(18)
        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.size: size,
            UIFontDescriptor.AttributeName.family: UIFont.systemFont(ofSize: size).familyName,
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold
            ]
        ])
        titleLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
        
        let titleView = UIStackView(arrangedSubviews: [titleLabel, activityIndicator])
        titleView.spacing = 8
        
        navigationItem.titleView = titleView
    }
    
    func hideActivityIndicator() {
        if let localityName = self.localityName {
            self.navigationItem.title = "Listings Near \(localityName)"
        } else {
            self.navigationItem.title = "Nearby Listings"
        }
        self.navigationItem.titleView = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showDetailViewSegue,
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
            else {
                return
            }
        let listing = listings[indexPath.row]
        detailViewController.listing = listing
        detailViewController.distance = listingDistanceFromCurrentLocation(listing)
    }
    
    private func listingDistanceFromCurrentLocation(_ listing: Listing) -> CLLocationDistance? {
        guard let currentLocation = self.currentLocation else { return nil }
        let listingLocation = CLLocation(latitude: listing.location.lat, longitude: listing.location.long)
        return listingLocation.distance(from: currentLocation)
    }
    
    private func currentLocationDidChange() {
        self.getListingsForLocation(currentLocation!)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation!) { (placemark, error) in
            guard error == nil else {
                print(error!) // TODO
                return
            }
            let currentPlacemark = placemark?.first
            if let locality = currentPlacemark?.subLocality {
                self.localityName = locality
            }
        }
    }
    
}

extension ListingResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = self.listings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listing") as! ListingResultsTableViewCell
        cell.updateListing(listing)
        
        if let currentLocation = self.currentLocation {
            let listingLocation = CLLocation(latitude: listing.location.lat, longitude: listing.location.long)
            let distance = listingLocation.distance(from: currentLocation)
            cell.updateDistance(distance)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showDetailViewSegue, sender: tableView.cellForRow(at: indexPath))
    }
    
}

extension ListingResultsViewController: CLLocationManagerDelegate {
    
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
