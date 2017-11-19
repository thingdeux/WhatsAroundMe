//
//  BaseNavigationControllerViewController.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class BaseNavigationControllerViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.barStyle = .blackOpaque        
        self.navigationBar.tintColor = UIColor.primaryText
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
