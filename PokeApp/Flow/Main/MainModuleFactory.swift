//
//  MainModuleFactory.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol MainModuleFactory {
    func makePokemonListView() -> PokemonListView
    
    func makePokemonDetailView() -> PokemonDetailView
}
