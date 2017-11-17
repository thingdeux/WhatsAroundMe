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
    private let currentLocationPermission: CLAuthorizationStatus = .notDetermined
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
        self.locationManager.requestWhenInUseAuthorization()
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😤 Location Failed With error \(error)")
        self.locationRetrievedHandler?(.error)
    }
}

