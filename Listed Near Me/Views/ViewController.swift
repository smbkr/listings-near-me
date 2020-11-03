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
    private var listingsTable = ListingsTableViewController()
    private var mapView = MKMapView()
    private var statusBarBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    /// Internal state
    private var currentLocation: CLLocation? {
        didSet {
            if mapViewRegionDidChangeFromUserInteraction() == false {
                guard let currentLocation = currentLocation else { return }
                mapView.centerOnLocation(currentLocation)
            }
        }
    }
    private var pendingListingsRequest: DispatchWorkItem?
    
    /// Models
    private let listingsDB = try! ListingsDatabase.open()
    private var listings = [Listing]() {
        didSet {
            DispatchQueue.main.async {
                self.listingsTable.listings = self.listings
                self.reloadMapAnnotations()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupFloatingPanel()
        NotificationCenter.default.addObserver(forName: .LocationUpdated, object: nil, queue: nil) { (notification) in
            if let newLocation = notification.userInfo?["location"] as? CLLocation {
                self.currentLocation = newLocation
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurStatusBar()
    }
    
    private func setupFloatingPanel() {
        floatingPanel.set(contentViewController: listingsTable)
        floatingPanel.track(scrollView: listingsTable.tableView)
        floatingPanel.layout = FloatingPanelBottomTipLayout()
        floatingPanel.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        floatingPanel.surfaceView.appearance = appearance
        floatingPanel.surfaceView.contentPadding.top = 30
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
        mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        let ukRegion = MKCoordinateRegion(.world) // FIXME: Should only allow zooming to extent of UK
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: ukRegion),
            animated: true
        )
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance(750)),
            animated: true
        )
        mapView.register(
            ListingAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: ListingAnnotationViewReuseIdentifier
        )
        
        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func blurStatusBar() -> Void {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            statusBarBlurView.frame = statusBarFrame
            view.addSubview(statusBarBlurView)
        } else {
            statusBarBlurView.removeFromSuperview()
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
                    let aDistance = currentLocation.distance(from: a.location)
                    let bDistance = currentLocation.distance(from: b.location)
                    
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
        mapView.addAnnotations(listings)
    }
}

// MARK: Map

extension ViewController: MKMapViewDelegate {
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: ListingAnnotationViewReuseIdentifier,
            for: annotation
        )
        return view
    }
}
