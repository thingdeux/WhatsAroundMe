//
//  Misc+Extensions.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

extension UIViewController {
    final func hideKeyboardWhenNotFocusedOnSearchBar() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc final func dismissKeyboard() {
        self.view.endEditing(true)
    } 
}

/*
    Apple is very much against changing default stylings on certain elements like UISearchBar.  Had to get a bit creative
    To make this fall inline with the design: Borrowed from -> https://forums.developer.apple.com/thread/85226
 */
extension UISearchBar {
    func setSearchUIElements(to color: UIColor, placeHolderText: String) {        
        // using this to set the text color of the 'Cancel' button since the search bar ignores the global tint color property
        UISearchBar.appearance().tintColor = color
        
        // Search bar placeholder text color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: color])
        
        // Search bar text color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: color]
        
        // Insertion cursor color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = color
        
        // Changes the tint color of the magnifying glass icon
        if let textFieldInsideSearchBar = self.getSubview(type: UITextField.self),
           let searchIconImageView = textFieldInsideSearchBar.leftView as? UIImageView {
            searchIconImageView.image = searchIconImageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            searchIconImageView.tintColor = UIColor.white
        }
    }
}

extension UIView {
    func getSubview<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        let element = (svs.filter { $0 is T }).first
        
        return element as? T
    }
}
