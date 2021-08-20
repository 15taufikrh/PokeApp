//
//  MainCoordinator.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {
    
    private let router: Router
    private let factory: MainModuleFactory
    
    init(router: Router, factory: MainModuleFactory) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        showPokemonListView()
    }
    
    private func showPokemonListView() {
        let view = factory.makePokemonListView()
        router.setRootModule(view, hideBar: false)
        
        
        view.onPokemonTapped = { [weak self] (pokemon) in
            guard let self = self else { return }
            self.showPokemonDetailView(pokemon: pokemon)
        }
    }
    
    private func showPokemonDetailView(pokemon:PokemonModel) {
        let view = factory.makePokemonDetailView()
        view.pokemon = pokemon
        router.push(view)
    }
}
