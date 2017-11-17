//
//  SearchService.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation
import Alamofire

class SearchService {
    typealias SearchResultsCompletionHandler = (_ response: SearchResponse?) -> Void
    
    /// Search Yelp API for businesses near a given lat/long with additional search criteria.
    func findNeardbyBusinesses(_ criteria: SearchCriteria, apiQueue: DispatchQueue = DispatchQueue.global(), completionHandler: @escaping SearchResultsCompletionHandler) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.authToken)"]
        let parameters: Parameters = [:]
        let searchUrl = Constants.Urls.baseUrl + Constants.Urls.businessSearchEndpoint
        let request = Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        request.responseData(queue: apiQueue) { (response) in
            if let json = response.result.value {
                do {
                    let apiResponse = try JSONDecoder().decode(SearchResponse.self, from: json)
                    completionHandler(apiResponse)
                } catch {
                    print("SearchService: Search Result Error \(error)")
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
        
    }
}

// MARK: Namespaced Convenience Definitions
extension SearchService {
    struct SearchCriteria {
        let searchTerm: String
        let latitude: Int
        let longitude: Int
        let sortedBy: SortCriteria = .bestMatch
        
        enum SortCriteria: String {
            case bestMatch = "best_match"
            case highestRating = "rating"
            case mostReviews = "review_count"
            case closest = "distance"
        }
    }
    
    fileprivate enum Constants {
        static let maxRadiusInMeters = 10000 // 6 Miles
        static let maxResultsPerCall = 100
        
        /*
           The API uses OAUTH2 authentication however this token will not expire until 2038 per Yelp documentation
           https://www.yelp.com/developers/documentation/v3/authentication - didn't feel it was necessary to implement
           OAuth2 Auth flow for this test but will do so if required please reach out.
         */
        static let authToken = "fyJvsBDSGDaMwk8oLcR3D_yAbsAxcX_TwxR7R9zgz04f9ZIwoH3l6MWDyhiOYP1jbXSohJdrXTca1_gXcEC79zkvxgUVqDqf06SPH9ZxOlS3xN9NbeNj2tp0VDYOWnYx"
        
        enum Urls {
            static let baseUrl = "https://https://api.yelp.com/v3/"
            static let businessSearchEndpoint = "businesses/search"
        }
    }
}
