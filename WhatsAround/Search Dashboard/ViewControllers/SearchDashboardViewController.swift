//
//  SearchDashboardViewController.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

typealias EmptyCompletionHandler = () -> Void

class SearchDashboardViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var infoLabel: UILabel!       
    
    private var currentlyLoading: Bool = false
    private let model = SearchDashboardModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIAndDelegates()
        self.hideKeyboardWhenNotFocusedOnSearchBar()
        self.searchBar.setSearchUIElements(to: UIColor.primaryText, placeHolderText: "Search Nearby")
                
        self.model.setHandlers { [weak self] (updateType) in
            self?.updateUI(for: updateType)
        }
    }        
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUIAndDelegates() {
        self.collectionView.register(UINib(nibName: SearchResultCollectionViewCell.Constants.nibName, bundle: nil),
                                     forCellWithReuseIdentifier: SearchResultCollectionViewCell.Constants.reuseId)
                
        self.view.backgroundColor = UIColor.primaryColor
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        self.collectionView.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 8.0, right: 16.0)
    }
    
    private func setLoading(_ isLoading: Bool, forceHideInfoLabel: Bool? = nil) {
        // If we're already in a loading state - transition out and vice-versa.
        // If we receive a call to setLoading and we're already in that state return.
        guard isLoading != self.currentlyLoading else { return }
        DispatchQueue.main.async {
            if isLoading != true {
                UIView.animate(withDuration: 0.4, animations: {
                    self.loadingIndicator.alpha = 0
                    self.collectionView.alpha = 1
                    self.infoLabel.alpha = 0
                }, completion: { (_) in
                    if let forceHideInfoLabel = forceHideInfoLabel, forceHideInfoLabel != false {
                        self.infoLabel.alpha = 0
                    } else {
                        self.infoLabel.alpha = 1
                    }
                })
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    self.collectionView.alpha = 0
                    self.loadingIndicator.alpha = 1
                    self.infoLabel.alpha = 0
                }, completion: { (_) in
                    self.infoLabel.alpha = 0
                })
            }
            self.currentlyLoading = isLoading
            // Info Label will be visible for all states save 'newSearchResults'
            // In the event of a newSearchResults call this infoLabel will be set to the correct alpha.
        }
    }
    
    /// UI State Refresh Handler - anytime the model calls for a state update this will be run.
    private func updateUI(for type: SearchDashboardModel.UIUpdateType) {
        switch (type) {
            case .newSearchResults:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollCollectionViewToTop()
                    self.setLoading(false, forceHideInfoLabel: true)
                }
            case .loading:
                self.setLoading(true)
            case .timeout, .noSearchResultsFound:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.infoLabel.text = "No Results Found"
                }
                self.setLoading(false)
            case .locationPermissionsDenied, .errorRetrievingLocationPermissions:
                // Note: For a real app - this should be handled differently - because you only get one shot to ask the user
                // For this permission it's better to have a custom view explaining why you need this permission and prevent
                // Actually having CoreLocation pop the permissions alert so that you can be sure the user will accept it when the time
                // Comes and you don't have to guide them to settings.
                // For this test I'm just providing an on-screen prompt for location permission denial.
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.infoLabel.text = "Location Permission Denied"
                        self.setLoading(false)
                    })
                }
        }
        
    }
    
    private func scrollCollectionViewToTop() {
        if self.model.state.allSearchResults.count > 0 {
            DispatchQueue.main.async {
                let topItem = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: topItem, at: UICollectionViewScrollPosition.top, animated: false)
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let detailViewController = segue.destination as? SearchDetailViewController, let selectedBusiness = self.model.state.selectedBusiness {
           detailViewController.setup(with: selectedBusiness)
            self.model.clearSelectedBusiness()
        }
    }
    
}

// MARK: CollectionView DataSource
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

// MARK: CollectionViewDelegate
extension SearchDashboardViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.model.state.allSearchResults.count {
            let business = self.model.state.allSearchResults[indexPath.row]
            
            self.model.setSelectedBusiness(business)
            self.performSegue(withIdentifier: "DashboardToDetailSegue", sender: self)
        }
    }
}

// MARK: CollectionView Flow Layout
extension SearchDashboardViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds
        
        // Maintain 3 columns for smaller devices.
        if Device.isSizeOrSmaller(.Inches_4) {
            return CGSize(width: screen.width / 3.6, height: screen.height / 4.15)
        }
        return CGSize(width: screen.width / 3.5, height: screen.height / 4.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if Device.IS_5_5_INCHES_OR_LARGER() {
            return -30.0
        }
        // Want a nice tight fit between cells
        return -14.0
    }
}

// MARK: UISearchBar Delegate
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
