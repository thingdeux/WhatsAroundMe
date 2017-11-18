//
//  RankedTitleCollectionViewCell.swift
//  WhatsAround
//
//  ReUsable Collection View Cell with Labels that will work for Review Ranking and as a header
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

protocol DetailPageDisplayable {}

protocol RankedTextDisplayable : DetailPageDisplayable {
    var rankedTitleName: String { get }
    var rankedTitleValue: Float { get }
}

protocol RankedReviewable : DetailPageDisplayable {    
}

class RankedTitleCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
