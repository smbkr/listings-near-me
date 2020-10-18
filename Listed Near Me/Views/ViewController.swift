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
    private var listingsTableView = UITableView()
    private var mapView = MKMapView()
    
    /// Internal state
    private var statusBarWasBlurred = false
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var pendingListingsRequest: DispatchWorkItem?
    
    /// Models
    private let listingsDB = try! ListingsDatabase.open()
    private var listings = [Listing]() {
        didSet {
            DispatchQueue.main.async {
                self.listingsTableView.reloadData()
                self.reloadMapAnnotations()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupTableView()
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        blurStatusBar()
    }
    
    private func setupTableView() {
        listingsTableView.dataSource = self
        listingsTableView.delegate = self
    }
    
    private func setupFloatingPanel() {
        let tableViewController = UIViewController()
        tableViewController.view.addSubview(listingsTableView)
        listingsTableView.translatesAutoresizingMaskIntoConstraints = false
        listingsTableView.topAnchor.constraint(equalTo: tableViewController.view.topAnchor).isActive = true
        listingsTableView.leftAnchor.constraint(equalTo: tableViewController.view.leftAnchor).isActive = true
        listingsTableView.bottomAnchor.constraint(equalTo: tableViewController.view.bottomAnchor).isActive = true
        listingsTableView.rightAnchor.constraint(equalTo: tableViewController.view.rightAnchor).isActive = true
        
        floatingPanel.set(contentViewController: tableViewController)
        floatingPanel.track(scrollView: listingsTableView)
        floatingPanel.layout = FloatingPanelBottomTipLayout()
        floatingPanel.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        floatingPanel.surfaceView.appearance = appearance
        floatingPanel.surfaceView.contentPadding.top = 30
    }
    
    private func setupMapView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
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

// MARK: Listings

extension ViewController {
    private func refreshListings() {
        Debouncer.shared.perform(afterDelayMs: 500) { [self] in
            do {
                let listings = try self.listingsDB.withinBounds(self.mapView.visibleMapRect)
                self.listings = listings.sorted { (a, b) -> Bool in
                    guard let currentLocation = self.currentLocation else { return true }
                    let aLocation = CLLocation(latitude: a.location.lat, longitude: a.location.long)
                    let bLocation = CLLocation(latitude: b.location.lat, longitude: b.location.long)
                    let aDistance = currentLocation.distance(from: aLocation)
                    let bDistance = currentLocation.distance(from: bLocation)
                    
                    return aDistance < bDistance
                }
            } catch let error {
                // FIXME
                print(error)
            }
        }
    }
    
    private func reloadMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for listing in listings {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: listing.location.lat, longitude: listing.location.long
            )
            annotation.title = listing.name
            if let grade = listing.grade {
                annotation.subtitle = "Grade \(grade)"
            }
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: Map

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if mapViewRegionDidChangeFromUserInteraction() == false {
            mapView.zoomToFit(centeredOn: mapView.userLocation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        // FIXME
        print("Failed to get user location: \(error)")
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        refreshListings()
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if (recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended) {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: Location Manager

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // FIXME
        print(error)
    }
}

// MARK: Table View

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "listing")
        let listing = listings[indexPath.row]
        cell.textLabel?.text = listing.name
        let listingLocation = CLLocation(latitude: listing.location.lat, longitude: listing.location.long)
        let distance = currentLocation?.distance(from: listingLocation)
        cell.detailTextLabel?.text = distance?.humanReadableString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
}
