//
//  PokemonDetailAPI.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

protocol PokemonDetailAPI: ClientAPI {
    func request(param:String) -> Single<PokemonDetailResponse>
}
