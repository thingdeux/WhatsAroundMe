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
        // Set Navbar Color
        self.navigationBar.barStyle = .black        
        // Set Back Button Color
        self.navigationBar.tintColor = UIColor(named: "PrimaryText")!
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
