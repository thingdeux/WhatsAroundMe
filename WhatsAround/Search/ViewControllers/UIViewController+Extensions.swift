//
//  UIViewController+Extensions.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenNotFocusedOnSearchBar() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    } 
}

