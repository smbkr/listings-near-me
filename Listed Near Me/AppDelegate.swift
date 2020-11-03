//
//  AppDelegate.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var locationManager: CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        configureAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }

    private func configureAppearance() -> Void {
        UIButton.appearance().cornerRadius = Theme.buttonRadius
    }

}

// MARK: Location Manager

extension NSNotification.Name {
  static let LocationUpdated = NSNotification.Name(rawValue: "location_updated")
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(
            Notification(name: .LocationUpdated, object: self, userInfo: ["location": locations.first])
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // FIXME
        print(error)
    }
}
