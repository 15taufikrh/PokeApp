//
//  PokemonDetailRepositoryImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation

import RxSwift

class PokemonDetailRepositoryImpl: PokemonDetailRepository {
    
    
    
    private let pokemonDetailAPI: PokemonDetailAPI
    private let pokemonSpeciesAPI: PokemonSpeciesAPI
    private let pokemonTypeAPI: PokemonTypeAPI
    private let pokemonChainAPI: PokemonChainAPI
    private let pokemonController: PokemonController
    private let disposeBag = DisposeBag()
    
    init(pokemonDetailAPI:PokemonDetailAPI, pokemonSpeciesAPI:PokemonSpeciesAPI, pokemonTypeAPI:PokemonTypeAPI, pokemonChainAPI:PokemonChainAPI, pokemonController: PokemonController) {
        self.pokemonDetailAPI = pokemonDetailAPI
        self.pokemonSpeciesAPI = pokemonSpeciesAPI
        self.pokemonTypeAPI = pokemonTypeAPI
        self.pokemonChainAPI = pokemonChainAPI
        self.pokemonController = pokemonController
    }
    
    func requestPokemonDetail(name: String) -> Single<PokemonDetailResponse> {
        return Single.create(subscribe: { (observer) in
            
            self.pokemonDetailAPI
                .request(param: name)
                .subscribe(onSuccess: { (result) in
                    observer(.success(result))
                }, onError: { (err) in
                    observer(.error(err))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func requestPokemonSpecies(pokemon: PokemonModel) -> Single<PokemonSpeciesResponse> {
        return Single.create(subscribe: { (observer) in
            
            self.pokemonSpeciesAPI
                .request(pokemonID: pokemon.index)
                .subscribe(onSuccess: { (result) in
                    observer(.success(result))
                }, onError: { (err) in
                    observer(.error(err))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func requestPokemonType(type:Int) -> Single<PokemonTypeResponse> {
        return Single.create(subscribe: { (observer) in
            
            self.pokemonTypeAPI
                .request(typeID: type)
                .subscribe(onSuccess: { (result) in
                    observer(.success(result))
                }, onError: { (err) in
                    observer(.error(err))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func requestPokemonChain(type:Int) -> Single<PokemonChainResponse> {
        return Single.create(subscribe: { (observer) in
            
            self.pokemonChainAPI
                .request(typeID: type)
                .subscribe(onSuccess: { (result) in
                    observer(.success(result))
                }, onError: { (err) in
                    observer(.error(err))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func requestPokemonDetailFromDB(name: String) -> Single<PokemonModel> {
        return Single.create(subscribe: { (observer) in
            
            let result = self.pokemonController.readByName(name: name)
            switch result {
            case .success(let pokemon):
                
                let types = pokemon.types?.split(separator: ",").map({ value in
                    return String(value)
                })
                
                let model =  PokemonModel(index: Int(pokemon.index),
                                          name: pokemon.name ?? "",
                                          url: pokemon.url ?? "",
                                          types: types ?? [],
                                          imageURL: pokemon.imageUrl ?? "")
                
                observer(.success(model))
                break
            case .failure(let error):
                observer(.error(error))
                break
            }
            return Disposables.create()
        })
    }
}
