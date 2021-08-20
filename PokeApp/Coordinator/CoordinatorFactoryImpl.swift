//
//  CoordinatorFactoryImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func makeMainCoordinator(router: Router) -> Coordinator & MainCoordinatorOutput {
        return MainCoordinator(router: router, factory: ModuleFactoryImpl())
    }
    
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImpl(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController.controllerFromStoryboard(.main)
        }
    }
    
}

extension UIViewController {
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    class func controllerFromStoryboard(_ storyboard: Storyboard) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
}

enum Storyboard: String {
    case main = "Main"
    case login = "Login"
}

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

