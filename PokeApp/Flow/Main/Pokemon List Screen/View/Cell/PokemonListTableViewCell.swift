//
//  PokemonListTableViewCell.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var pokemonTypeStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
