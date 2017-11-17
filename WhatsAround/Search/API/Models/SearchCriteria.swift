//
//  SearchCriteria.swift
//  WhatsAround
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation

protocol APISearchProcessable {
    typealias SearchResultsCompletionHandler = (_ response: SearchResponse?) -> Void
    func findNearbyBusinesses(_ criteria: SearchCriteria, apiQueue: DispatchQueue, completionHandler: @escaping SearchResultsCompletionHandler)
}

struct SearchCriteria {
    let searchTerm: String
    let latitude: Double
    let longitude: Double
    let sortedBy: SortCriteria = .bestMatch
    /// Make sure to check the maxResultsPerCall constant in before chunking with offset.
    /// Ideally you should get the next set using the same amounts.
    let offset: Int
    
    enum SortCriteria: String {
        case bestMatch = "best_match"
        case highestRating = "rating"
        case mostReviews = "review_count"
        case closest = "distance"
    }
    
    enum Constants {
        static let maxRadiusInMeters = 10000 // 6 Miles
        static let maxResultsPerCall = 100
    }
}
