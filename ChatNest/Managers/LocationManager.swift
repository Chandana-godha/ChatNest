 import Foundation
 import UIKit
 import CoreLocation
 
 class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private(set) var userLocation: CLLocation?
     private(set) var coord: CLLocationCoordinate2D?
    func start() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // to get user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else {
            return
        }
        
        print("userLocation in LocMgr is:")
        NSLog("\(userLocation)")
        
        let latValue = userLocation.coordinate.latitude
        let longValue = userLocation.coordinate.longitude
        
        print("location values in LocMgr:")
        print("user latitude = \(latValue)")
        print("user longitude = \(longValue)")
        
        self.userLocation = userLocation
        self.coord  = CLLocationCoordinate2DMake(latValue, longValue)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        
    }
    
    
 }
