//
//  ViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 11/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

class ViewController: UIViewController {
    
    var fpc = FloatingPanelController()
    var listingResultsVC = ListingResultsViewController()
    var map = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        setupMapView()
        setupFloatingPanel()
    }
    
    private func setupFloatingPanel() {
        fpc.set(contentViewController: listingResultsVC)
        fpc.track(scrollView: listingResultsVC.tableView)
        fpc.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        fpc.surfaceView.appearance = appearance
        
        fpc.surfaceView.contentPadding.top = 20
    }
    
    private func setupMapView() {
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsUserLocation = true
        map.showsScale = true
        map.showsCompass = true
        map.showsBuildings = true
        map.showsTraffic = false
        
        view.addSubview(map)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
