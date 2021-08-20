//
//  AppCoordinator.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

final class AppCoordinator: BaseCoordinator {
    
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeMainCoordinator(router: self.router)
        addDependency(coordinator)
        coordinator.start()
    }
}
