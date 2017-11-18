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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("PERFORM SEGUE CALLED")
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
