//
//  AbilitiesTableViewCell.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import UIKit

class AbilitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var abilityDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
