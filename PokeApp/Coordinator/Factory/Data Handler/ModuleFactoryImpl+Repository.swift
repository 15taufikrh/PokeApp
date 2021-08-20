//
//  ModuleFactoryImpl+Repository.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

extension ModuleFactoryImpl: RepositoryModuleFactory {
    
    func makePokemonListRepository() -> PokemonListRepository {
        return PokemonListRepositoryImpl(pokemonAPI: makePokemonListAPI(), pokemonDetailAPI: makePokemonDetailAPI(), pokemonController: makePokemonController())
    }
    
    func makePokemonDetailRepository() -> PokemonDetailRepository {
        return PokemonDetailRepositoryImpl(pokemonDetailAPI: makePokemonDetailAPI(), pokemonSpeciesAPI: makePokemonSpeciesAPI(), pokemonTypeAPI: makePokemonTypeAPI(), pokemonChainAPI: makePokemonChainAPI(), pokemonController: makePokemonController())
    }
}
