//
//  SearchService.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation
import Alamofire

class YelpAPIService: APISearchProcessable {
    // TODO - Low Priority: I have a hard dependency on Alamofire here - if I've extra time I will split this out into an APICore protocol and allow for dependency injection
    // when making all of my API Calls.  Will make this testable.
    init() {
        assert(!YelpAPIService.Constants.authToken.isEmpty, "😬 You need a Yelp API AuthToken to continue.")
    }
    
    static func generateRequest(url: String, parameters: Parameters? = nil) -> DataRequest {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.authToken)"]
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    /// Search Yelp API for businesses near a given lat/long with additional search criteria.
    final func findNearbyBusinesses(_ criteria: SearchCriteria, apiQueue: DispatchQueue = DispatchQueue.global(), completionHandler: @escaping SearchResultsCompletionHandler) {
        let parameters: Parameters = [
            "term": criteria.searchTerm,
            "latitude": criteria.latitude,
            "longitude": criteria.longitude,
            "offset": criteria.offset,
            "sort_by": criteria.sortedBy.rawValue,
            "limit": SearchCriteria.Constants.maxResultsPerCall,
            "radius": criteria.searchRadiusInMeters,
        ]
        let searchUrl = Constants.Urls.baseUrl + Constants.Urls.businessSearchEndpoint
        let request = YelpAPIService.generateRequest(url: searchUrl, parameters: parameters)
        
        // TODO - Low Priority: Retry logic necessary? Maybe check reachability to make sure the user has internet first.
        request.responseData(queue: apiQueue) { (response) in            
            if let json = response.result.value {
                do {
                    let apiResponse = try JSONDecoder().decode(SearchResponse.self, from: json)
                    completionHandler(apiResponse)
                } catch {
                    print("😭 YelpAPIService: Search Result Error \(error)")
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getDetailedInformation(for business: Business, apiQueue: DispatchQueue = DispatchQueue.global(), completionHandler: @escaping BusinessDetailsCompletionHandler) {
        let requestUrl = "\(Constants.Urls.baseUrl)\(Constants.Urls.businessDetailEndpoint)\(business.id)"
        let request = YelpAPIService.generateRequest(url: requestUrl)
        
        request.responseData(queue: apiQueue) { (response) in
            if let json = response.result.value {
                do {
                    let business = try JSONDecoder().decode(Business.self, from: json)
                    // Now that we've acquired the photos for this business - get the reviews.
                    YelpAPIService.getReviews(for: business, apiQueue: apiQueue, completionHandler: completionHandler)
                } catch {
                    print("😭 YelpAPIService: Business Details Error \(error)")
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /*  Get up to 3 reviews for a particular business
        The Yelp API will unfortunately only ever return 3 reviews according to:
        https://www.yelp.com/developers/documentation/v3/business_reviews
     */
    static private func getReviews(for business: Business, apiQueue: DispatchQueue = DispatchQueue.global(), completionHandler: @escaping BusinessDetailsCompletionHandler) {
        let baseUrl = "\(Constants.Urls.baseUrl)\(Constants.Urls.businessReviewsEndpoint)"
        let requestUrl = baseUrl.replacingOccurrences(of: "<id>", with: business.id)
        let request = YelpAPIService.generateRequest(url: requestUrl)
        
        // If this method has been called - at worst we've already got detailed business info but just no reviews.
        // All failure handlers will at the very least pass the business details back.
        request.responseData(queue: apiQueue) { (response) in
            if let json = response.result.value {
                do {
                    let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: json)
                    var updatedBusiness = business
                    updatedBusiness.reviews = reviewResponse.reviews
                    completionHandler(updatedBusiness)
                } catch {
                    print("😭 YelpAPIService: Review Acquisition Error \(error)")
                    completionHandler(business)
                }
            } else {
                completionHandler(business)
            }
        }
    }
}

// MARK: Namespaced Convenience Definitions
extension YelpAPIService {
    fileprivate enum Constants {
        /*
         
           The API uses OAUTH2 authentication however this token will not expire until the year 2038 per Yelp documentation.
           https://www.yelp.com/developers/documentation/v3/authentication - didn't feel it was necessary to implement
           OAuth2 Auth flow for this test but will do so if required.
         
         */
        static let authToken = ""
        
        enum Urls {
            static let baseUrl = "https://api.yelp.com/v3/"
            static let businessSearchEndpoint = "businesses/search"
            static let businessDetailEndpoint = "businesses/"
            static let businessReviewsEndpoint = "businesses/<id>/reviews"
        }
    }
}
