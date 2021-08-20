//
//  ModuleFactoryImpl+VM.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

extension ModuleFactoryImpl: VMModuleFactory {
    func makePokemonListVM() -> PokemonListVM{
        return PokemonListVM(repository: makePokemonListRepository())
    }
    
    func makePokemonDetailVM() -> PokemonDetailVM{
        return PokemonDetailVM(repository: makePokemonDetailRepository())
    }
}
