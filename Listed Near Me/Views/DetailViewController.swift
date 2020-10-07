//
//  DetailViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 14/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    public var listing: Listing?
    public var distance: CLLocationDistance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let listing = listing {
            self.navigationItem.title = listing.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EmbedDetailTableView",
            let detailTableViewController = segue.destination as? DetailTableViewController else {
                return
        }
        detailTableViewController.listing = self.listing
        detailTableViewController.distance = self.distance
    }
        
}
