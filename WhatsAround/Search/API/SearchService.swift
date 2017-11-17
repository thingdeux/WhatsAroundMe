//
//  SearchService.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation
import Alamofire

class SearchService: APISearchProcessable {
    // TODO: I have a hard dependency on Alamofire here - if I've extra time I will split this out into an APICore protocol and allow for dependency injection
    // when making all of my API Calls.  Will make this testable.
    
    /// Search Yelp API for businesses near a given lat/long with additional search criteria.
    func findNearbyBusinesses(_ criteria: SearchCriteria, apiQueue: DispatchQueue = DispatchQueue.global(), completionHandler: @escaping SearchResultsCompletionHandler) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.authToken)"]
        let parameters: Parameters = [
            "latitude": criteria.latitude,
            "longitude": criteria.longitude,
            "offset": criteria.offset,
            "limit": SearchCriteria.Constants.maxResultsPerCall,
            "radius": SearchCriteria.Constants.maxRadiusInMeters
        ]
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
    fileprivate enum Constants {        
        /*
         
           The API uses OAUTH2 authentication however this token will not expire until the year 2038 per Yelp documentation.
           https://www.yelp.com/developers/documentation/v3/authentication - didn't feel it was necessary to implement
           OAuth2 Auth flow for this test but will do so if required.
         
         */
        static let authToken = "fyJvsBDSGDaMwk8oLcR3D_yAbsAxcX_TwxR7R9zgz04f9ZIwoH3l6MWDyhiOYP1jbXSohJdrXTca1_gXcEC79zkvxgUVqDqf06SPH9ZxOlS3xN9NbeNj2tp0VDYOWnYx"
        
        enum Urls {
            static let baseUrl = "https://api.yelp.com/v3/"
            static let businessSearchEndpoint = "businesses/search"
        }
    }
}
