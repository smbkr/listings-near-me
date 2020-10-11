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
    
    /// Sub-views
    private var floatingPanel = FloatingPanelController()
    private var listingResultsView = ListingResultsViewController()
    private var mapView = MKMapView()
    
    /// Internal state
    private var statusBarWasBlurred = false
    private var currentLocation: CLLocation? {
        didSet {
            refreshListings()
        }
    }
    
    /// Models
    private let listingsDB = try! ListingsDatabase.open()
    private var listings = [Listing]() {
        didSet {
            listingResultsView.listings = listings
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        blurStatusBar()
    }
    
    private func setupFloatingPanel() {
        floatingPanel.set(contentViewController: listingResultsView)
        floatingPanel.track(scrollView: listingResultsView.tableView)
        floatingPanel.layout = FloatingPanelBottomTipLayout()
        
        floatingPanel.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        floatingPanel.surfaceView.appearance = appearance
        floatingPanel.surfaceView.contentPadding.top = 20
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        mapView.showsTraffic = false
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance(750)),
            animated: true
        )
        
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func blurStatusBar() -> Void {
        if statusBarWasBlurred { return }
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            blurEffectView.frame = statusBarFrame
            view.addSubview(blurEffectView)
            statusBarWasBlurred = true
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentLocation = userLocation.location
        if mapViewRegionDidChangeFromUserInteraction() == false {
            mapView.zoomToFit(centeredOn: mapView.userLocation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        // FIXME
        print("Failed to get user location: \(error)")
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
}

extension ViewController {
    // TODO: This should happen on another thread
    private func refreshListings() {
        guard let location = currentLocation else { return }
        do {
            listings =  try listingsDB.getNear(location)
        } catch let error {
            // FIXME
            print(error)
        }
    }
}
