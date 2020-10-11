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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupFloatingPanel()
    }
    
    private func setupFloatingPanel() {
        fpc.set(contentViewController: listingResultsVC)
        fpc.track(scrollView: listingResultsVC.tableView)
        fpc.layout = FloatingPanelBottomTipLayout()
        
        fpc.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        fpc.surfaceView.appearance = appearance
        fpc.surfaceView.contentPadding.top = 20
    }
    
    private func setupMapView() {
        map.delegate = self
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsUserLocation = true
        map.showsScale = true
        map.showsCompass = true
        map.showsBuildings = true
        map.showsTraffic = false
        
        map.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance(750)),
            animated: true
        )
        
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
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentLocation = userLocation.location
        
        if mapViewRegionDidChangeFromUserInteraction() == false {
            map.zoomToFit(centeredOn: map.userLocation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        // FIXME
        print("Failed to get user location: \(error)")
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = map.subviews[0]
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


fileprivate class FloatingPanelBottomTipLayout: FloatingPanelBottomLayout {
    override final var initialState: FloatingPanelState {
        return .tip
    }
}
