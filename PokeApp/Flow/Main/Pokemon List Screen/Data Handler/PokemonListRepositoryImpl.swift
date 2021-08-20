//
//  PokemonListRepositoryImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import RxSwift

class PokemonListRepositoryImpl: PokemonListRepository {
    
    
    private let pokemonAPI: PokemonListAPI
    private let pokemonDetailAPI: PokemonDetailAPI
    private let pokemonController: PokemonController
    private let disposeBag = DisposeBag()
    
    init(pokemonAPI: PokemonListAPI,
         pokemonDetailAPI:PokemonDetailAPI,
         pokemonController: PokemonController ) {
        self.pokemonAPI = pokemonAPI
        self.pokemonDetailAPI = pokemonDetailAPI
        self.pokemonController = pokemonController
    }
    
    func requestPokemonList() -> Single<[PokemonModel]> {
        return Single.create(subscribe: { (observer) in
            
            let result = self.pokemonController.read()
            switch result {
            case .success(let models):
                var results = models.map { pokemon -> PokemonModel in
                    let types = pokemon.types?.split(separator: ",").map({ value in
                        return String(value)
                    })
                    
                    return PokemonModel(index: Int(pokemon.index),
                                        name: pokemon.name ?? "",
                                        url: pokemon.url ?? "",
                                        types: types ?? [],
                                        imageURL: pokemon.imageUrl ?? "")
                }.sorted {
                    $0.index < $1.index
                }

                observer(.success(results))
                break
            case .failure(let error):
                observer(.error(error))
                break
            }
            return Disposables.create()
        })
    }
    
    func requestPokemonListFromAPI(model: PokemonListBody) -> Single<[PokemonModel]> {
        return Single.create(subscribe: { (observer) in
        
        
        self.pokemonAPI.request(parameters: self.inputTransformJson(from: model))
            .map({ (response) -> [PokemonModel] in
                return self.outputTransformModel(from: response)
            })
            .subscribe(onSuccess: { (models) in
                let _ = self.pokemonController.insertBulk(models: models)
                observer(.success(models))
            }, onError: { (err) in
                observer(.error(err))
            })
            .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    private func inputTransformJson(from object: PokemonListBody) -> [String: Any] {
        if let param = object.dictionary {
            return param
        }
        return [String: Any]()
    }
    
    private func outputTransformModel(from object: PokemonListResponse) -> [PokemonModel] {
        let model = object.results.map { (response) -> PokemonModel in
            
            var index = 0
            if let tempIndex = response.url.split(separator: "/").last{
                index = Int(tempIndex) ?? 0
            }
            
            return PokemonModel(index: index, name: response.name, url: response.url, types: [], imageURL: "")
        }
        return model
    }
    
    
    func requestPokemon(pokemon:PokemonModel) -> Single<PokemonModel> {
        
        return Single.create(subscribe: { (observer) in
            
            self.pokemonDetailAPI
                .request(param: pokemon.name)
                .subscribe(onSuccess: { (result) in
                    var newPokemon = pokemon
                    if let image = result.sprites.other?.officialArtwork.frontDefault{
                        newPokemon.imageURL = image
                    }else{
                        newPokemon.imageURL = result.sprites.frontDefault
                    }
                    
                    var types:[String] = []
                    for type in result.types{
                        types.append(type.type.name)
                    }
                    newPokemon.types = types
                    
                    let _ = self.pokemonController.update(pokemon: newPokemon)
                    
                    observer(.success(newPokemon))
                }, onError: { (err) in
                    observer(.error(err))
                })
                .disposed(by: self.disposeBag)
                
            
            return Disposables.create()
        })
    }
}
