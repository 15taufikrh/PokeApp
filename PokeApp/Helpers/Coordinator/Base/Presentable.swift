//
//  Presentable.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
    
    func availableViewController() -> UIViewController? {
        return self
    }
    
    func wrapInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
