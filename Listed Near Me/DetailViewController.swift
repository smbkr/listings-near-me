//
//  DetailViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 14/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public var listing: Listing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        if let listing = listing {
            self.navigationItem.title = listing.name
            titleLabel.text = listing.name
            if let grade = listing.grade {
                gradeLabel.text = grade.description
            } else {
                gradeLabel.text = "Ungraded"
            }
            dateLabel.text = "Unknown"
        }
    }
}
