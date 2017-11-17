//
//  Location.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import Foundation

struct Location : Decodable {
    let city: String
    let country: String
    let state: String
    let zipCode: String
    let display_address: [String]
    
    private let address1: String?
    private let address2: String?
    private let address3: String?
    
    
    // Only intersted in One address for now - return a valid address
    // Starting with address1 and moving down the successive addresses if available.
    var address: String? {
        return self.address1 ?? self.address2 ?? self.address3
    }
}


/*
 Example Location Response (from /v3/businesses/search ...)
 
 {
 ...
    {
     "location": {
         "city": "San Francisco",
         "country": "US",
         "address2": "",
         "address3": "",
         "state": "CA",
         "address1": "375 Valencia St",
         "zip_code": "94103"
    }
 }
 
 */
