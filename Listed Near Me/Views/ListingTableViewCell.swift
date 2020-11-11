//
//  ListingTableViewCell.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 03/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import CoreLocation

class ListingTableViewCell: UITableViewCell {
    public var listing: Listing? {
        didSet {
            configureView()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        guard let listing = listing else { return }
        accessoryType = .disclosureIndicator
        textLabel?.text = listing.title
        
        let badge = UILabel()
        badge.text = listing.grade?.description ?? "?"
        badge.textAlignment = .center
        badge.textColor = .systemBackground
        badge.backgroundColor = listing.color
        badge.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        badge.layer.cornerRadius = 16
        badge.layer.masksToBounds = true
        imageView?.image = UIImage.imageWithLabel(badge)
    }
}
