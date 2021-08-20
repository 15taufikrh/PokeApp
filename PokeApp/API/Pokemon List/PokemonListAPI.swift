//
//  PokemonListAPI.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import RxSwift

protocol PokemonListAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<PokemonListResponse>
}
