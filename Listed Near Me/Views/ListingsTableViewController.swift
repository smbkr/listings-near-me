//
//  ListingsTableViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 03/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import CoreLocation

class ListingsTableViewController: UITableViewController {
    public var listings = [Listing]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .LocationUpdated, object: nil, queue: nil) { (notification) in
            if let newLocation = notification.userInfo?["location"] as? CLLocation {
                self.currentLocation = newLocation
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "listing")
        let listing = listings[indexPath.row]
        cell.textLabel?.text = listing.title
        let distance = currentLocation?.distance(from: listing.location)
        cell.detailTextLabel?.text = distance?.humanReadableString()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
}
