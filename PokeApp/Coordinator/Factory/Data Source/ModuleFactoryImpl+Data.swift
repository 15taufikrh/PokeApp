//
//  ModuleFactoryImpl+Data.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

class ModuleFactoryImpl: DataModuleFactory {
    
    func makeBaseHTTPClient() -> HTTPClient {
        return URLClient()
    }
    
    func makePokemonListAPI() -> PokemonListAPI {
        return PokemonListAPIImpl(httpClient: makeBaseHTTPClient())
    }
    
    func makePokemonDetailAPI() -> PokemonDetailAPI {
        return PokemonDetailAPIImpl(httpClient: makeBaseHTTPClient())
    }
    
    func makePokemonSpeciesAPI() -> PokemonSpeciesAPI {
        return PokemonSpeciesAPIImpl(httpClient: makeBaseHTTPClient())
    }
    
    func makePokemonTypeAPI() -> PokemonTypeAPI {
        return PokemonTypeAPIImpl(httpClient: makeBaseHTTPClient())
    }
    
    func makePokemonChainAPI() -> PokemonChainAPI {
        return PokemonChainAPIImpl(httpClient: makeBaseHTTPClient())
    }
    
    func makePokemonController() -> PokemonController {
        return PokemonController()
    }
}
