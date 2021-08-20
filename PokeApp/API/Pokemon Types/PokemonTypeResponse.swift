//
//  PokemonTypeResponse.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation

struct PokemonTypeResponse: Codable {
    let damageRelations: DamageRelations
    let name: String

    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
        case name
    }
}

// MARK: - DamageRelations
struct DamageRelations: Codable {
    let doubleDamageFrom, doubleDamageTo, halfDamageFrom, halfDamageTo: [NameURL]
    let noDamageFrom, noDamageTo: [NameURL]

    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}
