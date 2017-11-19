//
//  RoundedImageCollectionViewCell.swift
//  WhatsAround
//
//  Rounded Image Cell for image carousel
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit
import Kingfisher

class RoundedImageCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let reuseId = "RoundedImageCollectionViewCell"
    }    

    @IBOutlet private weak var imageBorder: UIView!
    @IBOutlet private weak var roundedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageBorder.layer.cornerRadius = 2.0
    }
    
    override func prepareForReuse() {
        self.roundedImageView.kf.cancelDownloadTask()
        self.roundedImageView.image = nil
    }
    
    final func setup(with url: String) {
        if let url = URL(string: url) {
            self.roundedImageView.kf.setImage(with: url)
        }
    }

}
