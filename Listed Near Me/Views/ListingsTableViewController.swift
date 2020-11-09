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
    private let cellReuseId = "listing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        NotificationCenter.default.addObserver(forName: .LocationUpdated, object: nil, queue: nil) { (notification) in
            if let newLocation = notification.userInfo?["location"] as? CLLocation {
                self.currentLocation = newLocation
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! ListingTableViewCell
        let listing = listings[indexPath.row]
        cell.listing = listing
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
}
