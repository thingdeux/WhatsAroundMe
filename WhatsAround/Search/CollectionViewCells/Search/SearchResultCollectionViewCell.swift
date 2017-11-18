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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    enum Constants {
        static let reuseId = "SearchResultCollectionViewCell"
        static let nibName = "SearchResultCollectionViewCell"
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
        }
        self.setupImage(with: result.imageUrl)
    }
    
    private func setupImage(with url: String) {
        if let url = URL(string: url) {
            self.imageView.kf.setImage(with: url)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.starLabel.text = nil
        self.nameLabel.text = nil
        self.imageView.image = nil
    }

}


