//
//  PokemonTypeAPI.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

protocol PokemonTypeAPI: ClientAPI {
    func request(typeID:Int) -> Single<PokemonTypeResponse>
}

