//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listings: [Listing] = []
    private let api = APIService()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func refreshLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = self.listings[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: listing.name)
        cell.textLabel?.text = listing.name
        if let grade = listing.grade {
        cell.detailTextLabel?.text = "Grade: \(grade)"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
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
        print("\(location)")
        self.api.getNear(location) { (result) in
             switch result {
                 case .success(let listings):
                     self.listings = listings
                     DispatchQueue.main.async {
                         self.tableView.reloadData()
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
