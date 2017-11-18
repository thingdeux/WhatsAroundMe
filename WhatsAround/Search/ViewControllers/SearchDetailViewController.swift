//
//  SearchDetailViewController.swift
//  WhatsAround
//
//  Created by Josh on 11/16/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    @IBOutlet fileprivate weak var ratingLabel: UILabel!
    @IBOutlet fileprivate weak var businessNameLabel: UILabel!    
    
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
