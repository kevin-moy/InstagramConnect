//
//  Extensions.swift
//  23andMe
//
//  Created by Kevin on 11/15/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

// Source: https://stackoverflow.com/questions/40015171/how-to-show-an-alert-from-another-class-in-swift
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
