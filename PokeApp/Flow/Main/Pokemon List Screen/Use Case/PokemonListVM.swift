//
//  PokemonListVM.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import RxSwift
import RxCocoa

class PokemonListVM {
    
    private let repository: PokemonListRepository
    private let loadingState = BehaviorRelay<Bool>(value: false)
    private let pokemonsRelay = BehaviorRelay<[PokemonModel]>(value: [])
    private let pokemonRelay = BehaviorRelay<PokemonModel?>(value: nil)
   
    
    var isLoadingShown: Driver<Bool> {
        return self.loadingState.asDriver().skip(1)
    }
    
    struct Input {
        let fetchTap: Observable<Void>
        let loadMoreTap: Observable<Void>
        let offset: Observable<Int>
    }
    
    struct Output {
        let pokemons: Driver<[PokemonModel]>
        let pokemon: Driver<PokemonModel?>
    }
    
    private let disposeBag = DisposeBag()
    
    init(repository: PokemonListRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        self.makeLoadMore(input)
        return Output(pokemons: pokemonsRelay.asDriver().skip(1),
                      pokemon: pokemonRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetchTap
            .withLatestFrom(input.offset)
            .compactMap { $0 }
            .subscribe(onNext: { (offset) in
                self.fetchPokemons(offset: offset)
            }).disposed(by: self.disposeBag)
    }
    
    private func fetchPokemons(offset:Int){
        self.repository
            .requestPokemonList()
            .subscribe (onSuccess: { (pokemons) in
                self.pokemonsRelay.accept(pokemons)
                if pokemons.count > 0{
                    self.fetchPokemonsDetail(pokemons: pokemons)
                }else{
                    self.fetchPokemonFromAPI(offset: pokemons.count)
                }
            }) { (error) in
                
                //handle error
            }.disposed(by: self.disposeBag)
    }
    
    
    private func makeLoadMore(_ input: Input) {
        input
            .loadMoreTap
            .withLatestFrom(input.offset)
            .compactMap { $0 }
            .subscribe(onNext: { (offset) in
                self.fetchPokemonFromAPI(offset: offset)
            }).disposed(by: self.disposeBag)
    }
    
    
    private func fetchPokemonFromAPI(offset: Int, limit:Int = 20){
        let model = PokemonListBody(offset: offset, limit: limit)
        
        self.repository.requestPokemonListFromAPI(model: model)
            .subscribe { (event) in
                switch event {
                case .success(let pokemons):
                    self.pokemonsRelay.accept(pokemons)
                    if pokemons.count > 0{
                        self.fetchPokemonsDetail(pokemons: pokemons)
                    }
                case .error(let err):
                    print(err)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchPokemonsDetail(pokemons:[PokemonModel]){
        for pokemon in pokemons{
//        if let pokemon = pokemons.first{
            if pokemon.imageURL == "" {
                self.repository.requestPokemon(pokemon: pokemon)
                    .subscribe { (event) in
                        switch event {
                        case .success(let result):
                            self.pokemonRelay.accept(result)
                        case .error(let err):
                            print(err)
                        }
                    }
                    .disposed(by: disposeBag)
            }
        }
    }
}
