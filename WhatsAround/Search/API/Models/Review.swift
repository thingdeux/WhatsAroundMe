//
//  Review.swift
//  WhatsAround
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

struct ReviewResponse : Decodable {
    var reviews: [Review]
}

struct ReviewUser : Decodable {
    let name: String
    private let image_url: String
    
    var imageUrl: String {
        return self.image_url
    }
}

struct Review : Decodable {
    let url: String
    let rating: Float
    let user: ReviewUser
    
    private let time_created: String
    private let text: String
    
    // Computed Vars using iOS Standard Naming Conventions and offering more clarity.
    // Only keeping underscores for time_created / text
    // To save time and not have to implement CodingKeys
    var reviewDate: String {
        return self.time_created
    }
    
    var reviewText: String {
        return self.text
    }
}
