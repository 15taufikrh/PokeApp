//
//  VMModuleFactory.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

protocol VMModuleFactory {
    func makePokemonListVM() -> PokemonListVM
    func makePokemonDetailVM() -> PokemonDetailVM
}
