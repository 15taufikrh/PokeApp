//
//  PokemonDetailVM.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import RxSwift
import RxCocoa

class PokemonDetailVM {
    
    private let repository: PokemonDetailRepository
    private let loadingState = BehaviorRelay<Bool>(value: false)
    private let pokemonDetailRelay = BehaviorRelay<PokemonDetailResponse?>(value: nil)
    private let pokemonSpeciesRelay = BehaviorRelay<PokemonSpeciesResponse?>(value: nil)
    private let pokemonTypeRelay = BehaviorRelay<PokemonTypeResponse?>(value: nil)
    private let pokemonChainsRelay = BehaviorRelay<[PokemonChainModel]>(value: [])
    private let pokemonChainRelay = BehaviorRelay<(PokemonChainModel?, Bool)>(value: (nil, false))
   
    private var pokemonChains:[PokemonChainModel] = []
    
    var isLoadingShown: Driver<Bool> {
        return self.loadingState.asDriver().skip(1)
    }
    
    struct Input {
        let fetchTap: Observable<Void>
        let pokemon: Observable<PokemonModel?>
    }
    
    struct Output {
        let pokemonDetail: Driver<PokemonDetailResponse?>
        let pokemonSpecies: Driver<PokemonSpeciesResponse?>
        let pokemonType: Driver<PokemonTypeResponse?>
        let pokemonChains: Driver<[PokemonChainModel]>
        let pokemonChain: Driver<(PokemonChainModel?, Bool)>
    }
    
    private let disposeBag = DisposeBag()
    
    init(repository: PokemonDetailRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        return Output(pokemonDetail: pokemonDetailRelay.asDriver().skip(1),
                      pokemonSpecies: pokemonSpeciesRelay.asDriver().skip(1),
                      pokemonType: pokemonTypeRelay.asDriver().skip(1),
                      pokemonChains: pokemonChainsRelay.asDriver().skip(1),
                      pokemonChain: pokemonChainRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetchTap
            .withLatestFrom(input.pokemon)
            .compactMap { $0 }
            .subscribe(onNext: { (pokemon) in
                self.fetchPokemonDetail(pokemon: pokemon)
                self.fetchPokemonSpecies(pokemon:pokemon)
            }).disposed(by: self.disposeBag)
    }
    
    private func fetchPokemonDetail(pokemon:PokemonModel){
        self.repository
            .requestPokemonDetail(name: pokemon.name)
            .subscribe { (event) in
                switch event {
                case .success(let result):
                    self.pokemonDetailRelay.accept(result)
                    
                    self.fetchPokemonType(pokemon: result)
                    
                case .error(let err):
                    print(err)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchPokemonSpecies(pokemon:PokemonModel){
        self.repository
            .requestPokemonSpecies(pokemon: pokemon)
            .subscribe { (event) in
                switch event {
                case .success(let result):
                    self.pokemonSpeciesRelay.accept(result)
                    self.fetchPokemonChain(pokemon: result)
                case .error(let err):
                    print(err)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchPokemonType(pokemon:PokemonDetailResponse){
        
        for type in pokemon.types{
            if let typeID = Int(type.type.url.split(separator: "/").last ?? "0"){
                
                self.repository
                    .requestPokemonType(type: Int(typeID))
                    .subscribe { (event) in
                        switch event {
                        case .success(let result):
                            self.pokemonTypeRelay.accept(result)
                        case .error(let err):
                            print(err)
                        }
                    }
                    .disposed(by: disposeBag)
            }
        }
    }
    
    private func fetchPokemonChain(pokemon:PokemonSpeciesResponse){
        
        if let typeID = Int(pokemon.evolutionChain.url.split(separator: "/").last ?? "0"){
            
            self.repository
                .requestPokemonChain(type: Int(typeID))
                .subscribe { (event) in
                    switch event {
                    case .success(let result):
                        self.pokemonChains = []
                        self.processPokemonChain(chain: result.chain)
                    case .error(let err):
                        print(err)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
    
    
    private func processPokemonChain(chain:Chain){
        if let evolveTo = chain.evolvesTo.first, let evolutionDetail = evolveTo.evolutionDetails.first{
            
            pokemonChains.append(
                PokemonChainModel(from: chain.species.name,
                                  to: evolveTo.species.name,
                                  level: evolutionDetail.minLevel ?? 0,
                                  fromImageURL: "",
                                  toImageURL: ""))
            self.processPokemonChain(chain: evolveTo)
        }else{
            self.pokemonChainsRelay.accept(pokemonChains)
            self.processImagePokemonChains()
        }
    }
    
    private func processImagePokemonChains(){
        for chain in pokemonChains{
            self.retrieveImagePokemon(chain: chain, isFrom: true)
            self.retrieveImagePokemon(chain: chain, isFrom: false)
        }
    }
    
    private func retrieveImagePokemon(chain:PokemonChainModel, isFrom:Bool){
        var chain = chain
        self.repository
            .requestPokemonDetailFromDB(name: isFrom ? chain.from : chain.to)
            .subscribe (onSuccess: { (pokemon) in
                if isFrom{
                    chain.fromImageURL = pokemon.imageURL
                }else{
                    chain.toImageURL = pokemon.imageURL
                }
                self.pokemonChainRelay.accept((chain, isFrom))
            }) { (error) in
                //handle error, load from API
                self.retrieveImageFromAPI(chain: chain, isFrom: isFrom)
                
            }.disposed(by: self.disposeBag)
    }
    
    private func retrieveImageFromAPI(chain:PokemonChainModel, isFrom:Bool){
        var chain = chain
        
        self.repository
            .requestPokemonDetail(name: isFrom ? chain.from : chain.to)
            .subscribe { (event) in
                switch event {
                case .success(let result):
                    var url = ""
                    if let image = result.sprites.other?.officialArtwork.frontDefault{
                        url = image
                    }else{
                        url = result.sprites.frontDefault
                    }
                    
                    if isFrom{
                        chain.fromImageURL = url
                    }else{
                        chain.toImageURL = url
                    }
                    self.pokemonChainRelay.accept((chain, isFrom))
                    
                    
                case .error(let err):
                    print(err)
                }
            }
            .disposed(by: disposeBag)
    }
}
