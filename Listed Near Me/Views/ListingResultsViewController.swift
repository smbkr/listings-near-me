//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class ListingResultsViewController: UITableViewController {
    let exampleData = [
        "St Paul's Cathedral",
        "Tate Modern",
        "Bank",
        "St Pancras"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "result")
    }

}

// MARK: Data Source

extension ListingResultsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result")!
        cell.textLabel?.text = exampleData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleData.count
    }
}
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//    }
    
//    @IBAction private func refreshLocation(_ sender: Any?) {
//        listings = []
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
//
//    private func getListingsForLocation(_ location: CLLocation) {
//        showActivityIndicator()
//        do {
//            listings =  try self.db.getNear(location)
//        } catch let error {
//            print(error) // TODO: Better error handling
//        }
//        self.hideActivityIndicator()
//    }
    
//    func showActivityIndicator() {
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
//        activityIndicator.color = .black
//        activityIndicator.startAnimating()
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Loading"
//
//        let size = CGFloat(18)
//        let fontDescriptor = UIFontDescriptor(fontAttributes: [
//            UIFontDescriptor.AttributeName.size: size,
//            UIFontDescriptor.AttributeName.family: UIFont.systemFont(ofSize: size).familyName,
//            UIFontDescriptor.AttributeName.traits: [
//                UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold
//            ]
//        ])
//        titleLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
//
//        let titleView = UIStackView(arrangedSubviews: [titleLabel, activityIndicator])
//        titleView.spacing = 8
//
//        navigationItem.titleView = titleView
//    }
//
//    func hideActivityIndicator() {
//        if let localityName = self.localityName {
//            self.navigationItem.title = "Listings Near \(localityName)"
//        } else {
//            self.navigationItem.title = "Nearby Listings"
//        }
//        self.navigationItem.titleView = nil
//    }
//
//    private func listingDistanceFromCurrentLocation(_ listing: Listing) -> CLLocationDistance? {
//        guard let currentLocation = self.currentLocation else { return nil }
//        let listingLocation = CLLocation(latitude: listing.location.lat, longitude: listing.location.long)
//        return listingLocation.distance(from: currentLocation)
//    }
    
//    private func currentLocationDidChange() {
//        self.getListingsForLocation(currentLocation!)
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(currentLocation!) { (placemark, error) in
//            guard error == nil else {
//                print(error!) // TODO
//                return
//            }
//            let currentPlacemark = placemark?.first
//            if let locality = currentPlacemark?.subLocality {
//                self.localityName = locality
//            }
//        }
//    }
    

//extension ListingResultsViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            print("Something is wrong with the location") // TODO: Better error handling
//                return
//            }
//
//            self.currentLocation = location
//        }
//
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Failed to get user location: \(error)")
//        }
//
//}
