//
//  PokemonDetailRepository.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import RxSwift

protocol PokemonDetailRepository {
    func requestPokemonDetail(name:String) -> Single<PokemonDetailResponse>
    func requestPokemonSpecies(pokemon:PokemonModel) -> Single<PokemonSpeciesResponse>
    func requestPokemonType(type:Int) -> Single<PokemonTypeResponse>
    func requestPokemonChain(type:Int) -> Single<PokemonChainResponse>
    
    func requestPokemonDetailFromDB(name:String) -> Single<PokemonModel>
}
