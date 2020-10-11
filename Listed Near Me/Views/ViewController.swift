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
    
    private var fpc = FloatingPanelController()
    private var listingResultsVC = ListingResultsViewController()
    private var map = MKMapView()
    private var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
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
        
        blurStatusBar()
    }
    
    private func blurStatusBar() {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.frame = statusBarFrame
        view.addSubview(blurEffectView)
    }
    
    private func refreshLocation(_ sender: Any?) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            // FIXME
            print("Something is wrong with the location")
            return
        }
        
        self.currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // FIXME
        print("Failed to get user location: \(error)")
    }
}
