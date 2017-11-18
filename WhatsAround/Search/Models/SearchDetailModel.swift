//
//  SearchDetailModel.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

class SearchDetailModel {
    private(set) var state: State?
    
    init(with business: Business, completionHandler: @escaping EmptyCompletionHandler) {
        YelpAPIService.getDetailedInformation(for: business) { [weak self](business) in
            if let business = business {
                self?.state = State(business)
                completionHandler()
            } else {
                print("😭 Unable to expand business information")
                completionHandler()
            }
        }
    }
}

// MARK: Convenience Definitions
extension SearchDetailModel {
    struct State {
        /// All items in the detail page collection view will have to adhere to DetailPageDisplayable
        /// This will include the image carousel - the reviews - and the title/rank header
        private(set) var items = [DetailPageDisplayable]()
        
        private let business: Business
        private var photos = [String]()
        private let reviews: [Review]?
        
        init(_ business: Business) {
            self.photos = business.photos ?? []
            self.reviews = business.reviews
            self.business = business
            self.setupDisplayableItems()
        }
        
        private mutating func setupDisplayableItems() {
            // First -> Name and Rank
            self.items.append(self.business)
            // Second -> Image Carousel
            if self.photos.count > 0 {
               self.items.append(ImageCarousel(imageUrls: self.photos))
            }
            // Third and over -> Reviews (Each with their own cell)
            if let reviews = self.reviews {
                for review in reviews {
                    self.items.append(review)
                }
            }
        }
    }
    
    enum UIUpdateType {
        case loading
        case ready
    }
    
    struct ImageCarousel : ImageCarouselScrollable {
        var imageUrls: [String]
    }
}
