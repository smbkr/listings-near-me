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
    private var tableViewController = ListingsTableViewController()
    private var mapViewController = MapViewController()
    private var statusBarBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    /// Internal state
    private var pendingListingsRequest: DispatchWorkItem?
    
    /// Models
    private let listingsDB = try! ListingsDatabase.open()
    private var listings = [Listing]() {
        didSet {
            self.tableViewController.listings = self.listings
            self.mapViewController.listings = self.listings
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapViewController.view)
        self.addChild(mapViewController)
        mapViewController.didMove(toParent: self)
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurStatusBar()
    }
    
    private func setupFloatingPanel() {
        floatingPanel.set(contentViewController: tableViewController)
        floatingPanel.track(scrollView: tableViewController.tableView)
        floatingPanel.layout = FloatingPanelBottomTipLayout()
        floatingPanel.addPanel(toParent: self)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8
        floatingPanel.surfaceView.appearance = appearance
        floatingPanel.surfaceView.contentPadding.top = 30
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
    // FIXME This is terrible, reimplement using delegate
    public func refreshListings() {
        Debouncer.shared.perform(afterDelayMs: 500) { [self] in
            do {
                self.listings = try self.listingsDB.withinBounds(self.mapViewController.visibleMapRect)
            } catch let error {
                // FIXME
                print(error)
            }
        }
    }
}
