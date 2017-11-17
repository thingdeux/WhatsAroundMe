//
//  Business.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation

struct SearchResponse : Decodable {
    var total: Int64
    var businesses: [Business]
}

struct Business: Decodable {
    let id: String
    let rating: Int
    let name: String
    let image_url: String
    let location: Location
    let distance: Double
    private let display_phone: String
    private let is_closed: Bool
    private let review_count: Int64
    
    // Computed Vars using iOS Standard Naming Conventions.
    // Only keeping underscores for is_closed / review_count
    // To save time and not have to implement CodingKeys
    var isClosed: Bool {
        return self.is_closed
    }
    
    var reviewCount: Int64 {
        return self.review_count
    }
    
    var prettyPhoneNumber: String {
        return self.display_phone
    }
    
    // Yelp website URL for this business
    private let url: String
    var websiteUrl: String {
        return self.url
    }
}

/*
    Example Response (from /v3/businesses/search ...)
 
     {
         "rating": 4,
         "price": "$",
         "phone": "+14152520800",
         "id": "four-barrel-coffee-san-francisco",
         "is_closed": false,
         "categories": [
             {
             "alias": "coffee",
             "title": "Coffee & Tea"
             }
         ],
         "review_count": 1738,
         "name": "Four Barrel Coffee",
         "url": "https://www.yelp.com/biz/four-barrel-coffee-san-francisco",
         "coordinates": {
            "latitude": 37.7670169511878,
            "longitude": -122.42184275
         },
         "image_url": "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg",
         "location": {
             "city": "San Francisco",
             "country": "US",
             "address2": "",
             "address3": "",
             "state": "CA",
             "address1": "375 Valencia St",
             "zip_code": "94103"
         },
 
        "distance": 1604.23,
         "transactions": ["pickup", "delivery"]
     }
 
 */

