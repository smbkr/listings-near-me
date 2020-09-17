//
//  ListingCell.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 16/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import CoreLocation

class ListingTableViewCell: UITableViewCell {
    
    public var listing: Listing?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func updateListing(_ listing: Listing) {
        self.listing = listing
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
    
    func updateDistance(_ distanceInMeters: CLLocationDistance) {
        if (distanceInMeters < 10) {
            distanceLabel.text = "\(distanceInMeters.rounded(toPlaces: 2)) m"
        }
        else if (distanceInMeters < 1000) {
            distanceLabel.text = "\(Int(distanceInMeters)) m"
        }
        else {
            let distanceInKm = distanceInMeters / 1000
            distanceLabel.text = "\(distanceInKm.rounded(toPlaces: 2)) km"
        }
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
