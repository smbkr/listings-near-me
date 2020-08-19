//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    private var listings: [Listing] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = self.listings[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = listing.name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = API()
        self.listings = api.getAll()
    }

}

