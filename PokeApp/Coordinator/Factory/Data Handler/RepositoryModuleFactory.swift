//
//  RepositoryModuleFactory.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

protocol RepositoryModuleFactory {
    func makePokemonListRepository() -> PokemonListRepository
    func makePokemonDetailRepository() -> PokemonDetailRepository
}
