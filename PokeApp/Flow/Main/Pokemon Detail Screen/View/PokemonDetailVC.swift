//
//  PokemonDetailVC.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonDetailVC: UIViewController, PokemonDetailView {
    
    
    private var fetchRelay = PublishRelay<Void>()
    private var pokemonRelay = BehaviorRelay<PokemonModel?>(value:nil)
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypeImageView: UIImageView!
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var pokemonDetailLabel: UILabel!
    @IBOutlet weak var statButton: UIButton!
    @IBOutlet weak var evolutionButton: UIButton!
    @IBOutlet weak var statView: UIStackView!
    @IBOutlet weak var evolutionView: UIStackView!
    @IBOutlet weak var statStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var abilityStackView: UIStackView!
    @IBOutlet weak var eggGroupStackView: UIStackView!
    @IBOutlet weak var hatchCycleLabel: UILabel!
    @IBOutlet weak var hatchStepLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    
    @IBOutlet weak var habitatLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var captureRateLabel: UILabel!
    @IBOutlet weak var normalSpriteImageView: UIImageView!
    @IBOutlet weak var shinySpriteImageView: UIImageView!
    var viewModel: PokemonDetailVM!
    var pokemon: PokemonModel!
    
    private var weakness:[String] = []
    private var widthWeaknessCell:CGFloat = 0.0
    private var pokemonChains:[PokemonChainModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        self.bindViewModel()
        
        self.title = pokemon.name.uppercased()
        
        self.pokemonRelay.accept(pokemon)
        self.fetchRelay.accept(())
    }
    
    private func setupUI() {
        
        self.statButton.isSelected = true
        self.statButton.backgroundColor = .primaryBlue
        
        widthWeaknessCell = (UIScreen.main.bounds.size.width - 110.0) / 3.0
        
        if let url = URL(string: pokemon.imageURL){
            self.pokemonImageView.kf.setImage(with: url)
        }
        
        self.pokemonNameLabel.text = pokemon.name.capitalized
        
        if let type = pokemon.types.first{
            self.pokemonTypeImageView.image = UIImage(named: type)
            self.pokemonTypeLabel.text = type.uppercased()
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let nib = UINib(nibName: "WeaknessCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "WeaknessCollectionViewCell")
        
    }
    
    func bindViewModel() {
        let input = PokemonDetailVM.Input(fetchTap: self.fetchRelay.asObservable(),
                                          pokemon: self.pokemonRelay.asObservable())
        let output = self.viewModel.transform(input)
        
        output.pokemonDetail.drive(onNext: { (pokemonDetail) in
            if let pokemonDetail = pokemonDetail{
                self.applyPokemonDetail(pokemonDetail: pokemonDetail)
            }
            
        }).disposed(by: self.disposeBag)
        
        output.pokemonSpecies.drive(onNext: { (pokemonSpecies) in
            if let pokemonSpecies = pokemonSpecies{
                self.applyPokemonSpecies(pokemonSpecies: pokemonSpecies)
            }
            
        }).disposed(by: self.disposeBag)
        
        output.pokemonType.drive(onNext: { (pokemonType) in
            if let pokemonType = pokemonType{
                for damage in pokemonType.damageRelations.doubleDamageFrom{
                    self.weakness.append(damage.name)
                }
                self.weakness = Array(Set(self.weakness))
                self.collectionView.reloadData()
                
                self.heightCollectionView.constant = (CGFloat(self.weakness.count) / 3.0).rounded(.up) * 50.0
            }
            
        }).disposed(by: self.disposeBag)
        
        output.pokemonChains.drive(onNext: { (pokemonChains) in
            self.pokemonChains = pokemonChains
            self.applyPokemonChains()
        }).disposed(by: self.disposeBag)
        
        output.pokemonChain.drive(onNext: { (pokemonChain, isFrom) in
            if let pokemonChain = pokemonChain{
                self.updatePokemonChain(pokemonChain: pokemonChain, isFrom: isFrom)
            }
        }).disposed(by: self.disposeBag)

    }
    
    private func applyPokemonDetail(pokemonDetail:PokemonDetailResponse){
        self.statStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        for stat in pokemonDetail.stats{
            let sView = StatView(frame: .zero)
            sView.statNameLabel.text = convertStatName(name:stat.stat.name)
            sView.statValueLabel.text = String(format: "%03d", stat.baseStat)
            sView.statProgressView.progress = Float(stat.baseStat) / 100.0
            statStackView.addArrangedSubview(sView)
        }
        
        
        self.abilityStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        for ability in pokemonDetail.abilities{
            let label = UILabel(frame: .zero)
            label.font = .systemFont(ofSize: 14.0)
            label.textColor = .primaryBlue
            label.text = ability.ability.name.capitalized
            self.abilityStackView.addArrangedSubview(label)
        }
        
        if let url = URL(string: pokemonDetail.sprites.frontDefault){
            normalSpriteImageView.kf.setImage(with: url)
        }
        
        if let url = URL(string: pokemonDetail.sprites.frontShiny){
            shinySpriteImageView.kf.setImage(with: url)
        }
    }
    
    private func applyPokemonSpecies(pokemonSpecies:PokemonSpeciesResponse){
        if let entries = pokemonSpecies.flavorTextEntries.filter({ $0.version.name == "ruby" }).first{
            self.pokemonDetailLabel.text = entries.flavorText.replacingOccurrences(of: "\n", with:  " ")
        }
        
        for habitat in pokemonSpecies.eggGroups{
            let label = UILabel(frame: .zero)
            label.font = .systemFont(ofSize: 14.0)
            label.textColor = .black
            label.textAlignment = .center
            label.text = habitat.name.capitalized
            self.eggGroupStackView.addArrangedSubview(label)
        }
        
        hatchStepLabel.text = "\((pokemonSpecies.hatchCounter * 220) + 1) Steps"
        hatchCycleLabel.text = "\(pokemonSpecies.hatchCounter) Cycles"
        
        let female = CGFloat(pokemonSpecies.genderRate) / 8.0
        let male = CGFloat(8 - pokemonSpecies.genderRate) / 8.0
        femaleLabel.text = "\(female * 100)%"
        maleLabel.text = "\(male * 100)%"
        
        captureRateLabel.text = "\(ceil(CGFloat(pokemonSpecies.captureRate) / 255.0 * 100)) %"
        habitatLabel.text = pokemonSpecies.habitat.name.capitalized
        generationLabel.text = pokemonSpecies.generation.name.replacingOccurrences(of: "-", with: " ").capitalized
        
    }
    
    private func applyPokemonChains(){
        evolutionView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        for chain in pokemonChains{
            let chainView = PokemonChainView(frame: .zero)
            chainView.fromSpecies = chain.from
            chainView.fromLabel.text = chain.from.capitalized
            chainView.toLabel.text = chain.to.capitalized
            if chain.level == 0{
                chainView.levelLabel.text = " "
            }else{
                chainView.levelLabel.text = "Lv. \(chain.level)"
            }
            
            chainView.heightAnchor.constraint(equalToConstant: 148.0).isActive = true
            
            evolutionView.addArrangedSubview(chainView)
        }
    }
    
    private func updatePokemonChain(pokemonChain:PokemonChainModel, isFrom:Bool){
        //find view first
        for subView in evolutionView.arrangedSubviews {
            if let chainView = subView as? PokemonChainView, chainView.fromSpecies == pokemonChain.from {
                if isFrom{
                    if let url = URL(string: pokemonChain.fromImageURL){
                        chainView.fromImageView.kf.setImage(with: url)
                    }
                }else{
                    if let url = URL(string: pokemonChain.toImageURL){
                        chainView.toImageView.kf.setImage(with: url)
                    }
                }
                return
            }
        }
    }
    
    
    @IBAction func didTapStat(_ sender: Any) {
        statButton.isSelected = true
        evolutionButton.isSelected = false
        statButton.backgroundColor = .primaryBlue
        evolutionButton.backgroundColor = .white
        
        evolutionView.isHidden = true
        statView.isHidden = false
    }
    
    @IBAction func didTapEvolution(_ sender: Any) {
        statButton.isSelected = false
        evolutionButton.isSelected = true
        statButton.backgroundColor = .white
        evolutionButton.backgroundColor = .primaryBlue
        
        evolutionView.isHidden = false
        statView.isHidden = true
    }
    
    
    private func convertStatName(name:String) -> String{
        switch name{
        case "hp":
            return "HP"
        case "attack":
            return "ATK"
        case "defense":
            return "DEF"
        case "special-attack":
            return "SATK"
        case "special-defense":
            return "SDEF"
        case "speed":
            return "SPD"
        default:
            return name.uppercased()
        }
        
    }
}

extension PokemonDetailVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weakness.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeaknessCollectionViewCell", for: indexPath) as! WeaknessCollectionViewCell
        
        cell.typeImageView.image = UIImage(named: self.weakness[indexPath.row])
        cell.typeLabel.text = self.weakness[indexPath.row].capitalized
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthWeaknessCell, height: 40.0)
    }
}
