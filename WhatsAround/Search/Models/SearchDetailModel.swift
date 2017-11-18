//
//  SearchDetailModel.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

class SearchDetailModel {
    private(set) var state: State
    
    init(with business: Business) {
        self.state = State(business)
        YelpAPIService.getDetailedInformation(for: business) { [weak self](business) in
            if let business = business {
                self?.state = State(business)
            }
        }
    }
}

// MARK: Convenience Definitions
extension SearchDetailModel {
    struct State {
        fileprivate(set) var business: Business
        fileprivate(set) var photos = [String]()
        fileprivate(set) var reviews: [Review]?
        
        init(_ business: Business) {
            self.photos = business.photos ?? []
            self.reviews = business.reviews
            self.business = business
        }
    }
    
    enum UIUpdateType {
        case loading
        case ready
    }
}
