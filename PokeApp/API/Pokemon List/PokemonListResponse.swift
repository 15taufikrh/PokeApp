//
//  PokemonListResponse.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next, previous: String?
    let results: [PokemonListModel]
}

// MARK: - Result
struct PokemonListModel: Codable {
    let name: String
    let url: String
}
