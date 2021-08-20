//
//  ModuleFactoryImple+Main.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import Foundation

extension ModuleFactoryImpl: MainModuleFactory{
    
    func makePokemonListView() -> PokemonListView {
        let vc = PokemonListVC()
        vc.viewModel = makePokemonListVM()
        return vc
    }
    
    func makePokemonDetailView() -> PokemonDetailView {
        let vc = PokemonDetailVC()
        vc.viewModel = makePokemonDetailVM()
        return vc
    }
}
