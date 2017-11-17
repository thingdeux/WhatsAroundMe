//
//  LocationService.swift
//  WhatsAround
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import CoreLocation

class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private var currentLocationPermission: CLAuthorizationStatus = .notDetermined
    private var locationRetrievedHandler: LocationRetrievalHandler?
    
    typealias LocationRetrievalHandler = (_ location: LocationDetail) -> Void
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    enum LocationDetail {
        case permissionDenied
        case unknown
        case error
        case authorized(CLLocation)
    }
    
    func getCurrentLocation(_ handler: @escaping LocationRetrievalHandler) {
        self.locationRetrievedHandler = handler
        
        // If we already have permission to use CoreLocation - request the location, if not prompt for permission.
        // The CLLocationManager delegate will handle the rest of the flow.
        switch (self.currentLocationPermission) {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.requestLocation()
            default:
                self.locationManager.requestWhenInUseAuthorization()
                print("👏🏾 Requesting Location Permission")
        }
    }
}

// MARK: Core Location Delegate
extension LocationService : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationRetrievedHandler?(.authorized(location))
        } else {
            self.locationRetrievedHandler?(.unknown)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            print("😤😭 Location Permission Denied")
            self.locationRetrievedHandler?(.unknown)
        case .authorizedAlways, .authorizedWhenInUse:
            print("👌🏾🔥 Location permission granted")
            self.locationManager.requestLocation()
        self.currentLocationPermission = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😤 Location Failed With error \(error)")
        self.locationRetrievedHandler?(.error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("😤 Location Failed With error \(String(describing: error))")
        self.locationRetrievedHandler?(.error)
    }
}

