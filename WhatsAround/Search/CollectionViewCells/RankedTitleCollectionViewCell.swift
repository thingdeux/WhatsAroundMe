//
//  RankedTitleCollectionViewCell.swift
//  WhatsAround
//
//  ReUsable Collection View Cell with Labels that will work for Review Ranking and as the detail header
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class RankedTitleCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let reuseId = "RankedTitleCollectionViewCell"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    final func setup(_ displayable: DetailPageDisplayable) {
        switch displayable {
        case let textDisplayable as RankedTextDisplayable:
            self.setupTextDisplayable(textDisplayable)
        case let reviewable as RankedReviewable:
            self.setupReviewableItem(reviewable)
        default:
            break
        }
    }
    
    private func setupReviewableItem(_ reviewable: RankedReviewable) {
        DispatchQueue.main.async {
            self.reviewDateLabel.alpha = 1
            self.reviewLabel.alpha = 1
            self.rankLabel.alpha = 1
            self.titleLabel.alpha = 1
            
            self.reviewDateLabel.text = reviewable.reviewDateTime
            self.rankLabel.text = reviewable.reviewRank.valueAsStars
            self.reviewLabel.text = reviewable.reviewText
            self.titleLabel.text = reviewable.reviewAuthor.name
            self.rankLabel.textColor = reviewable.reviewRank.starColor
        }
    }
    
    private func setupTextDisplayable(_ textDisplayable: RankedTextDisplayable) {
        DispatchQueue.main.async {
            self.reviewLabel.text = nil
            self.reviewDateLabel.text = nil
            self.reviewLabel.alpha = 0
            self.reviewDateLabel.alpha = 0
                        
            self.titleLabel.text = textDisplayable.rankedTitleName
            self.rankLabel.text = textDisplayable.rankedTitleValue.valueAsStars
            self.titleLabel.alpha = 1
            self.rankLabel.alpha = 1
            self.rankLabel.textColor = textDisplayable.rankedTitleValue.starColor
        }
    }

}
