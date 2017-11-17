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
