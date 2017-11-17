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
    
    private func updateUI(for type: SearchDashboardModel.UIUpdateType) {
        switch (type) {
            case .newSearchResults:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollCollectionViewToTop()
                    self.setLoading(false, forceHideInfoLabel: true)
                }
                return
            case .loading:
                self.setLoading(true)
                return
            case .timeout, .noSearchResultsFound:
                DispatchQueue.main.async {
                    self.infoLabel.text = "No Results Found"
                }
            case .locationPermissionsDenied, .errorRetrievingLocationPermissions:
                // Note: For a real app - this should be handled differently - because you only get one shot to ask the user
                // For this permission it's better to have a custom view explaining why you need this permission and prevent
                // Actually having apple pop the permissions alert so that you can be sure the user will accept it when the time
                // Comes and you don't have to guide them to settings.
                // For this test I'm just providing an on-screen prompt.
                DispatchQueue.main.async {
                    self.infoLabel.text = "Location Permission Denied, Please Enable in Settings"
                }
        }
        self.setLoading(false)
    }
    
    private func scrollCollectionViewToTop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Scroll collectionview back to top
            self.collectionView.setContentOffset(self.collectionView.contentOffset, animated: false)
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
