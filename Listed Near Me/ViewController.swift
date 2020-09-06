//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listings: [Listing] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIService()
        api.getAll() { (result) in
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

