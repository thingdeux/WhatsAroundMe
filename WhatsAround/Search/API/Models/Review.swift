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
    private let image_url: String?
    
    var imageUrl: String? {
        return self.image_url
    }
}

struct Review : Decodable {
    let url: String
    let rating: Float
    let user: ReviewUser
    
    private let time_created: String
    private let text: String
}

extension Review : RankedReviewable {
    var reviewText: String {
        return self.text
    }
    
    var reviewRank: Float {
        return self.rating
    }
    
    var reviewAuthor: ReviewUser {
        return self.user
    }
    
    var reviewDateTime: String {
        // The time_created format from the API is <DATE> <Time> - I only want the date
        // So I'm stripping it.
        let splitDate = self.time_created.split(separator: " ")
        return String(describing: splitDate.first ?? "")
    }
}


/*  Example Response - https://api.yelp.com/v3/businesses/<business-id>/reviews
 
 {
     "reviews":
        [
            {
             "url": "https://www.yelp.com/biz/p",
             "text": "Solid pizza can be hard to find but here is a secret Pizza Bowl is solid pizza. The owner promised it would be even better the next day...",
             "rating": 4,
             "user": {
                 "image_url": "https://s3-media3.fl.yelpcdn.com/photo/d1yDWZjnLS0iAwYOhD8J6Q/o.jpg",
                 "name": "Luke M."
             },
              "time_created": "2017-07-17 18:23:26"
             },
        ] ...
        }
    ]
     "total": 104,
     "possible_languages": ["en"]
}
 
 
 */
