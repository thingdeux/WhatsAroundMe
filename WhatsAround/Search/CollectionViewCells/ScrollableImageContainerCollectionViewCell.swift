//
//  ScrollableImageContainerCollectionViewCell.swift
//  WhatsAround
//
//  Created by Josh on 11/17/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class ScrollableImageContainerCollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var imageCollectionView: UICollectionView!
    
    enum Constants {
        static let reuseId = "ScrollableImageContainerCollectionViewCell"
        static let screenHeightDivisor: CGFloat = 2.5
        static let screenWidthDivisor: CGFloat = 1.20
    }
    
    fileprivate var imageUrls: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageCollectionView.register(UINib(nibName: RoundedImageCollectionViewCell.Constants.reuseId, bundle: nil),
                                          forCellWithReuseIdentifier: RoundedImageCollectionViewCell.Constants.reuseId)
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16)
    }
    
    final func setup(imageUrls: [String]) {
        self.imageUrls = imageUrls
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
}

extension ScrollableImageContainerCollectionViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ScrollableImageContainerCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width / Constants.screenWidthDivisor, height: screenSize.height / Constants.screenHeightDivisor)
    }
}

extension ScrollableImageContainerCollectionViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedImageCollectionViewCell.Constants.reuseId, for: indexPath) as? RoundedImageCollectionViewCell {
            if indexPath.row < self.imageUrls.count {
                let imageUrl = self.imageUrls[indexPath.row]
                cell.setup(with: imageUrl)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
