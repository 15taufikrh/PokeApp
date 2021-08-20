//
//  Router.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

protocol Router: Presentable {
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    func present(_ module: Presentable?, animated: Bool, isWrapNavigation: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animation: RouterImpl.Animation)
    
    func popToRootModule(animated: Bool)
}
