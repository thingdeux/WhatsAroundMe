//
//  SearchDetailViewController.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    @IBOutlet fileprivate weak var detailCollectionView: UICollectionView!
    fileprivate var model: SearchDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.detailCollectionView.register(UINib(nibName: RankedTitleCollectionViewCell.Constants.reuseId, bundle: nil),
                                           
                                           forCellWithReuseIdentifier: RankedTitleCollectionViewCell.Constants.reuseId)
        
        self.detailCollectionView.register(UINib(nibName: ScrollableImageContainerCollectionViewCell.Constants.reuseId, bundle: nil),
                                           forCellWithReuseIdentifier: ScrollableImageContainerCollectionViewCell.Constants.reuseId)
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.detailCollectionView.dataSource = self
        self.detailCollectionView.delegate = self
        self.detailCollectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    final func setup(with business: Business) {
        self.model = SearchDetailModel(with: business) {
            DispatchQueue.main.async {
                self.detailCollectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.row < self.model?.state?.items.count ?? 0, let items = self.model?.state?.items else { return CGSize.zero }
        let displayableItem = items[indexPath.row]
        let screenSize = UIScreen.main.bounds
        
        switch displayableItem {
        case is RankedTextDisplayable:
            return CGSize(width: screenSize.width, height: screenSize.height / 10)
        case is ImageCarouselScrollable:
            return CGSize(width: screenSize.width, height: screenSize.height / ScrollableImageContainerCollectionViewCell.Constants.screenHeightDivisor)
        case is RankedReviewable:
            return CGSize(width: screenSize.width, height: screenSize.height / 8)
        default:
            return CGSize.zero
        }
    }
}

// MARK: UICollectionViewDataSource
extension SearchDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.model?.state?.items.count  ?? 0, let items = self.model?.state?.items {
            let displayableItem = items[indexPath.row]
            switch (displayableItem) {
            case let header as RankedTextDisplayable:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankedTitleCollectionViewCell.Constants.reuseId,
                                                                 for: indexPath) as? RankedTitleCollectionViewCell {
                    cell.setup(header)
                    return cell
                }
            case let imageCarousel as ImageCarouselScrollable:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollableImageContainerCollectionViewCell.Constants.reuseId,
                                                                 for: indexPath) as? ScrollableImageContainerCollectionViewCell {
                    cell.setup(imageUrls: imageCarousel.imageUrls)
                    return cell
                }
            case let review as RankedReviewable:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankedTitleCollectionViewCell.Constants.reuseId,
                                                                 for: indexPath) as? RankedTitleCollectionViewCell {
                    cell.setup(review)
                    return cell
                }
            default:
                break
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.state?.items.count ?? 0
    }
}

// MARK: Protocol definitions for detail page cells.
protocol DetailPageDisplayable {}

protocol ImageCarouselScrollable : DetailPageDisplayable {
    var imageUrls: [String] { get }
}

protocol RankedTextDisplayable : DetailPageDisplayable {
    var rankedTitleName: String { get }
    var rankedTitleValue: Float { get }
}

protocol RankedReviewable : DetailPageDisplayable {
    var reviewAuthor: ReviewUser { get }
    var reviewText: String { get }
    var reviewDateTime: String { get }
    var reviewRank: Float { get }
}
