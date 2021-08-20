//
//  CoordinatorFactory.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol CoordinatorFactory {
    func makeMainCoordinator(router: Router) -> Coordinator & MainCoordinatorOutput
}
