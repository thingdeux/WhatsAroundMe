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
        self.starLabel.text = nil
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
            let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 150, height: 150))
            self.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2)), .processor(resizeProcessor)], progressBlock: nil, completionHandler: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}


