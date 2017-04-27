//
//  Extensions.swift
//  ArduinoUnoWifi
//
//  Created by Sergey Didanov on 15.04.17.
//  Copyright © 2017 Sergey Didanov. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func topViewController(_ base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}
