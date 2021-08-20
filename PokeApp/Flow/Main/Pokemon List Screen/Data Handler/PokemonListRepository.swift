//
//  PokemonListRepository.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//


import RxSwift

protocol PokemonListRepository {
    func requestPokemonList() -> Single<[PokemonModel]>
    func requestPokemonListFromAPI(model: PokemonListBody) -> Single<[PokemonModel]>
    func requestPokemon(pokemon:PokemonModel) -> Single<PokemonModel>
}
