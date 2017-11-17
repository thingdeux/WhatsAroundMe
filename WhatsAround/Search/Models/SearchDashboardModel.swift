//
//  SearchDashboardModel.swift
//  WhatsAround
//
//  Model for the SearchDashboard View Controller
//  Pseudo MVVM implementation - only exposing a state object that can be used to build the ViewController.
//  The SearchService Will act as the Model.
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation
import CoreLocation

class SearchDashboardModel {
    typealias UIUpdateHandler = (_ updateType: UIUpdateType) -> Void
    
    private final let searchService = SearchService()
    private final let locationService = LocationService()
    
    private var currentOffset = 0
    private var currentSearchTerm: String?
    private var uiRefreshHandler: UIUpdateHandler?
    
    private let resultsMutationQueue = DispatchQueue(label: "land.josh.WhatsAround.resultsMutation", qos: .userInteractive)
    private let apiQueue = DispatchQueue(label: "land.josh.WhatsAround.apiQueue", qos: .userInitiated)
    
    
    // Exposed View Model
    fileprivate(set) var state = State()
    
    final func setHandlers(uiRefreshHandler: @escaping UIUpdateHandler) {
        self.uiRefreshHandler = uiRefreshHandler
    }
    
    /// Search for a specific term using Yelps API.
    /// Note: This will automatically request location permission
    final func search(for term: String) {
        self.currentSearchTerm = term
        self.locationService.getCurrentLocation { [weak self] (locationDetail) in
            guard let `self` = self else { return }
            switch (locationDetail) {
            case .authorized(let location):
                let searchCriteria = SearchCriteria(searchTerm: term, latitude: location.coordinate.latitude, longitude:location.coordinate.longitude, offset: self.currentOffset)
                self.search(searchCriteria)
            case .unknown:
                self.uiRefreshHandler?(.locationPermissionsDenied)
            case .error:
                self.uiRefreshHandler?(.errorRetrievingLocationPermissions)
            case .permissionDenied:
                self.uiRefreshHandler?(.locationPermissionsDenied)
            }
        }
    }
    
    /// Search for Nearby Businesses
    private final func search(_ criteria: SearchCriteria) {
        self.state.allSearchResults.removeAll()
        self.searchService.findNearbyBusinesses(criteria, apiQueue: self.apiQueue) { [weak self] (results) in
            guard let `self` = self else { return }
            if let results = results {
                // Using Sync DispatchQueue to lock mutation on searchResults
                self.resultsMutationQueue.sync {
                    self.state.allSearchResults.append(contentsOf: results.businesses)
                    self.uiRefreshHandler?(.newSearchResults)
                }
            } else {
                self.uiRefreshHandler?(.noSearchResultsFound)
            }
        }
    }
}

// MARK: Convenience Definitions
extension SearchDashboardModel {
    struct State {
        var allSearchResults = [Business]()
        var openBusinesses: [Business] {
            return self.allSearchResults.filter { $0.isClosed == false }
        }
    }
    
    enum UIUpdateType {
        case newSearchResults
        case noSearchResultsFound
        case timeout
        case locationPermissionsDenied
        case errorRetrievingLocationPermissions
    }
}
