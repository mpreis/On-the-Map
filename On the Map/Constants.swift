//
//  Constants.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//


import UIKit

// Constants

struct Constants {
    // MARK: UI
    struct UI {
        static let OrangeColor = UIColor(red: 1.0, green:0.6, blue:0.0, alpha: 0.7)
        static let LighterOrangeColor = UIColor(red: 1.0, green:0.7, blue:0.4, alpha: 1.0)
        static let DarkerOrangeColor = UIColor(red: 1.0, green:0.5, blue:0.0, alpha: 1.0)
        static let EvenDarkerOrangeColor = UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
        
        static let GreyColor = UIColor(red: 1.0, green:0.7, blue:0.4, alpha: 0.7)
        
        static let LoginColorTop = LighterOrangeColor.CGColor
        static let LoginColorBottom = DarkerOrangeColor.CGColor
    }
    
    // Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = "keyboardWillShow:"
        static let KeyboardWillHide: Selector = "keyboardWillHide:"
        static let KeyboardDidShow: Selector = "keyboardDidShow:"
        static let KeyboardDidHide: Selector = "keyboardDidHide:"
    }
}