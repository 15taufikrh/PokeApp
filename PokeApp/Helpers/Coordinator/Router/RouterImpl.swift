//
//  RouterImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit

final class RouterImpl: NSObject, Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: animated, isWrapNavigation: false)
    }
    
    func present(_ module: Presentable?, animated: Bool, isWrapNavigation: Bool) {
        guard var controller = module?.toPresent() else { return }
        if isWrapNavigation {
            controller = controller.wrapInNavigationController()
        }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBar: false, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBar: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.isNavigationBarHidden = hideBar
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        setRootModule(module, hideBar: hideBar, animation: .fadeIn)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool, animation: Animation) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
        
        switch animation {
        case .fadeIn:
            fadeAnimation(0.3)
        case .bottomUp:
            bottomUpAnimation()
        case .topDown:
            topDownAnimation()
        }
    }
    
    private func fadeAnimation(_ duration: CGFloat) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(duration)
        transition.type = .fade
        transition.subtype = .fromTop;
        rootController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    private func bottomUpAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        rootController?.view.layer.add(transition, forKey: nil)
    }
    
    private func topDownAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromBottom
        rootController?.view.layer.add(transition, forKey: nil)
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    enum Animation {
        case fadeIn
        case bottomUp
        case topDown
    }
}
