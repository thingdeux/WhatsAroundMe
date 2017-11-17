//
//  SearchDashboardViewController.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class SearchDashboardViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    
    private let model = SearchDashboardModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIAndDelegates()
        self.hideKeyboardWhenNotFocusedOnSearchBar()
        
        // Capture self to prevent leaks
        self.model.setHandlers { [weak self] (updateType) in
            self?.updateUI(for: updateType)
        }
    }
    
    private func setupUIAndDelegates() {
        self.collectionView.register(UINib(nibName: SearchResultCollectionViewCell.Constants.nibName, bundle: nil),
                                     forCellWithReuseIdentifier: SearchResultCollectionViewCell.Constants.reuseId)
        
        // Force unwrapping as this color is in the asset library and used widely throughout, it should crash if missing.
        self.view.backgroundColor = UIColor(named: "PrimaryColor")!
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
    }
    
    private func updateUI(for type: SearchDashboardModel.UIUpdateType) {
        // TODO: Update UI accordingly
        switch (type) {
            case .newSearchResults:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .timeout:
                break
            case .noSearchResultsFound:
                break
            case .locationPermissionsDenied:
                break
            case .errorRetrievingLocationPermissions:
                break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchDashboardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.state.allSearchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.Constants.reuseId, for: indexPath) as? SearchResultCollectionViewCell {
            if indexPath.row < self.model.state.allSearchResults.count {
                let displayable = self.model.state.allSearchResults[indexPath.row]
                cell.setup(with: displayable)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension SearchDashboardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension SearchDashboardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds        
        return CGSize(width: screen.width / 3.5, height: screen.height / 4)
    }
}


extension SearchDashboardViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchBar.text = nil
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            self.model.search(for: searchTerm)
        }
        self.dismissKeyboard()
        self.resignFirstResponder()
    }
}

/*
 if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
 
 }
 
 */
