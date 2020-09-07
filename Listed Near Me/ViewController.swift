//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listings: [Listing] = []
    private let api = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func refreshLocation(_ sender: Any) {
        let currentLocation = Location(long: 0, lat: 0)
        self.api.getNear(currentLocation) { (result) in
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
