//
//  PokemonListView.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import Foundation

protocol PokemonListView: BaseView {
    var viewModel: PokemonListVM! { get set }
    
    var onPokemonTapped: ((PokemonModel) -> Void)? { get set }
}
