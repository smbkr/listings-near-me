//
//  ListingCell.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 16/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    
    public var listing: Listing? {
        didSet {
            let listing = self.listing!
            nameLabel.text = listing.name
            if let grade = listing.grade {
                gradeLabel.text = grade.rawValue
                // TODO: Extract common colour palette
                var color: UIColor
                switch grade {
                    case .I:
                        color = .systemBlue
                    case .II:
                        color = .systemOrange
                    case .IIs:
                        color = .systemPurple
                }
                gradeLabel.backgroundColor = color
            }
            self.accessoryType = .disclosureIndicator
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
}
