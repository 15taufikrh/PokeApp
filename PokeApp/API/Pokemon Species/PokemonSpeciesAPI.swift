//
//  PokemonSpeciesAPI.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

protocol PokemonSpeciesAPI: ClientAPI {
    func request(pokemonID:Int) -> Single<PokemonSpeciesResponse>
}
