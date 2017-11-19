//
//  SearchResultCollectionViewCell.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit
import Kingfisher

protocol SearchResultDisplayable {
    var name: String { get }
    var rating: Float { get }
    var imageUrl: String { get }
}

class SearchResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    
    enum Constants {
        static let reuseId = "SearchResultCollectionViewCell"
        static let nibName = "SearchResultCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starLabel.text = nil
        self.nameLabel.text = nil
        self.imageView.image = nil
        self.borderView.layer.cornerRadius = 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.starLabel.text = nil
        self.nameLabel.text = nil
        // Make sure to cancel any errant image download tasks that haven't returned in enough
        // Time for the cell to not be re-used under it.
        self.imageView.kf.cancelDownloadTask()
    }
    
    func setup(with result: SearchResultDisplayable) {
        DispatchQueue.main.async {
            self.starLabel.text = result.rating.valueAsStars
            self.nameLabel.text = result.name
            self.starLabel.textColor = result.rating.starColor
        }
        self.setupImage(with: result.imageUrl)
    }
    
    private func setupImage(with url: String) {
        if let url = URL(string: url) {
            self.imageView.kf.setImage(with: url)
        }
    }
}


