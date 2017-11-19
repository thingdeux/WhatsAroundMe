//
//  UIColor+Extensions.swift
//  WhatsAround
//
//  Created by Josh on 11/19/17.
//  Copyright © 2017 Josh Land. All rights reserved.
//

import UIKit

/// Note: Force-Unwrapping these colors as color literals from the asset container is safe.
extension UIColor {
    static var rankColor: UIColor {
        return UIColor(named: "RankColor")!
    }
    
    static var primaryText: UIColor {
        return UIColor(named: "PrimaryText")!
    }
    
    static var secondaryText: UIColor {
        return UIColor(named: "SecondaryText")!
    }
    
    static var accentColor: UIColor {
        return UIColor(named: "AccentColor")!
    }
    
    static var primaryColor: UIColor {
        return UIColor(named: "PrimaryColor")!
    }
    
    static var secondaryColor: UIColor {
        return UIColor(named: "SecondaryColor")!
    }
}

