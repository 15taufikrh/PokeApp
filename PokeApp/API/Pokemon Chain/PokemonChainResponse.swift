//
//  PokemonChainResponse.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation

struct PokemonChainResponse: Codable {
    let chain: Chain
    let id: Int

    enum CodingKeys: String, CodingKey {
        case chain, id
    }
}

// MARK: - Chain
struct Chain: Codable {
    let evolutionDetails: [EvolutionDetail]
    let evolvesTo: [Chain]
    let species: NameURL

    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case species
    }
}

// MARK: - EvolutionDetail
struct EvolutionDetail: Codable {
    let minLevel: Int?
    let trigger: NameURL?
    let turnUpsideDown: Bool?

    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
        case trigger
        case turnUpsideDown = "turn_upside_down"
    }
}
