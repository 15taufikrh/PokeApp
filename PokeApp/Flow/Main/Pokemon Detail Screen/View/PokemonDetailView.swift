//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation

protocol PokemonDetailView: BaseView {
    var viewModel: PokemonDetailVM! { get set }
    var pokemon: PokemonModel! { get set }
}
