//
//  SearchCriteria.swift
//  WhatsAround
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

protocol APISearchProcessable {
    typealias SearchResultsCompletionHandler = (_ response: SearchResponse?) -> Void
    typealias BusinessDetailsCompletionHandler = (_ business: Business?) -> Void
    func findNearbyBusinesses(_ criteria: SearchCriteria, apiQueue: DispatchQueue, completionHandler: @escaping SearchResultsCompletionHandler)        
}

struct SearchCriteria {
    let searchTerm: String
    let latitude: Double
    let longitude: Double
    let sortedBy: SortCriteria
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
        static let maxRadiusInMeters = 40000 // ~25 Miles
        static let maxResultsPerCall = 50
    }
}

extension Float {
    /*
     I'm "cheating" here with stars and losing a bit of accuracy
     The Right way to do this is to allow for half-stars.... this is a hacky
     Way to do this as I feel like this codebase is already sufficiently bulky and I don't want to add more complexity.
     In the event that this is a real task the proper way to do this is to either have star image assets
     One for a full star and one for a half - and create small collection views under the images counting stars.
     Depending on performance (may be a bit rough depending on how many cells are on screen at once) a more performant
     Implementation would be to have an asset for each rating level - ex: One for 1 star, one for 1 and a half stars, 1 for 2 stars....etc
     As it stands I'm losing half star accuracy and simply making a string with star emojis.
     */
    var valueAsStars: String {
        let ratingValueRounded = Int(self)
        return String(repeatElement("★", count: ratingValueRounded))
    }
    
    var starColor: UIColor {
        if self >= 4.0 {
            return UIColor(named: "RankColor")!
        } else {
            return UIColor(named: "AccentColor")!
        }
    }
}
