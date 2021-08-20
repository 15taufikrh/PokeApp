//
//  PokemonChainView.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import UIKit

class PokemonChainView: UIView {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var toImageView: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    
    var fromSpecies:String!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let view = loadViewFromNib()
        view.frame = bounds
        
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
    }
}
