//
//  DataModuleFactory.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

protocol DataModuleFactory {
    func makeBaseHTTPClient() -> HTTPClient
    
    func makePokemonListAPI() -> PokemonListAPI
    func makePokemonDetailAPI() -> PokemonDetailAPI
    func makePokemonSpeciesAPI() -> PokemonSpeciesAPI
    func makePokemonTypeAPI() -> PokemonTypeAPI
    func makePokemonChainAPI() -> PokemonChainAPI
    
    func makePokemonController() -> PokemonController
}
