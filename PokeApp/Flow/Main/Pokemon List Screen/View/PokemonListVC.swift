//
//  PokemonListVC.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import RxSwift
import RxCocoa
import Kingfisher

class PokemonListVC: UIViewController, PokemonListView {
    
    var viewModel: PokemonListVM!
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private var fetchRelay = PublishRelay<Void>()
    private var loadMoreRelay = PublishRelay<Void>()
    private var offsetRelay = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()
    
    private var pokemons:[PokemonModel] = []
    
    
    private var canLoadMore = false
    private var onLoad = false
    
    var onPokemonTapped: ((PokemonModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        setupTableView()
        self.bindViewModel()
        
        self.title = "Pokemon"
        
        self.onLoad = true
        self.fetchRelay.accept(())
    }
    
    private func setupLoading() {
        self.loadingView.center = self.view.center
        self.loadingView.hidesWhenStopped = true
        self.loadingView.style = .gray
        self.view.addSubview(self.loadingView)
        
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "PokemonListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PokemonListTableViewCell")
        
    }
    
    
    func bindViewModel() {
        let input = PokemonListVM.Input(fetchTap: self.fetchRelay.asObservable(),
                                        loadMoreTap: self.loadMoreRelay.asObservable(),
                                        offset: self.offsetRelay.asObservable())
        let output = self.viewModel.transform(input)
        output.pokemons.drive(onNext: { (pokemons) in
            self.pokemons.append(contentsOf: pokemons)
            self.onLoad = false
            self.canLoadMore = pokemons.count == 20
            self.tableView.reloadData()
        }).disposed(by: self.disposeBag)
        
        output.pokemon.drive(onNext: { (pokemon) in
            if let pokemon = pokemon{
                self.updatePokemon(pokemon: pokemon)
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    func updatePokemon(pokemon:PokemonModel){
        //assume index = indexPath.row + 1
        let index = pokemon.index - 1
        if index < self.pokemons.count{
            self.pokemons[index] = pokemon
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

}


extension PokemonListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListTableViewCell", for: indexPath) as! PokemonListTableViewCell
        
        let pokemon = pokemons[indexPath.row]
        
        cell.nameLabel.text = pokemon.name
        cell.indexLabel.text = "#" + String(format: "%03d", pokemon.index)
        
        if let url = URL(string: pokemon.imageURL){
            cell.pokemonImageView.kf.setImage(with: url)
        }
        
        cell.pokemonTypeStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        for type in pokemon.types{
            let imageView = UIImageView(image: UIImage(named: type))
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
            cell.pokemonTypeStackView.addArrangedSubview(imageView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = self.pokemons.count - 1
        if !onLoad && indexPath.row == lastData && canLoadMore {
            onLoad = true
            self.offsetRelay.accept(self.pokemons.count)
            self.loadMoreRelay.accept(())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.onPokemonTapped?(pokemons[indexPath.row])
    }
    
}
