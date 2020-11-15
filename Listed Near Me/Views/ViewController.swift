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
    private var statusBarBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private var mapView = MKMapView()
    
    /// Internal state
    private var pendingListingsRequest: DispatchWorkItem?
    private var currentLocation: CLLocation? {
        didSet {
            if mapView.regionDidChangeFromUserInteraction() == false {
                guard let currentLocation = currentLocation else { return }
                mapView.centerOnLocation(currentLocation)
            }
        }
    }
    private let zoomMin = 500
    private let zoomMax = 6000 * 500
    
    /// Data
    private let listingsDB = try! ListingsDatabase.open()
    private var listings = [Listing]() {
        didSet {
            print("Received \(listings.count) listings")
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(listings)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurStatusBar()
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
        
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion.England),
            animated: true
        )
        
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: CLLocationDistance(zoomMin),
                maxCenterCoordinateDistance: CLLocationDistance(zoomMax)
            ),
            animated: true
        )
        
        if currentLocation == nil {
            let center = CLLocation(
                latitude: MKCoordinateRegion.England.center.latitude,
                longitude: MKCoordinateRegion.England.center.longitude
            )
            mapView.centerOnLocation(center, radiusMeters: Double(zoomMax))
        }
        
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
    
    private func setupFloatingPanel() {
        floatingPanel.layout = FloatingPanelBottomLayout()
        floatingPanel.isRemovalInteractionEnabled = true
        floatingPanel.setAppearance()
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

// MARK: - Listings

extension ViewController {
    public func refreshListings() {
        Debouncer.shared.perform(afterDelayMs: 500) { [self] in
            do {
                self.listings = try self.listingsDB.withinBounds(self.mapView.visibleMapRect)
            } catch let error {
                // FIXME
                print(error)
            }
        }
    }
}

// MARK: - Map View Delegate

extension ViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        refreshListings()
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let listing = view.annotation as? Listing else { return }
        print("Selected \(listing)")
    }
}
