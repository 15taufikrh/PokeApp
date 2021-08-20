//
//  StatView.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import UIKit

class StatView: UIView {

    @IBOutlet weak var statNameLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!
    @IBOutlet weak var statProgressView: UIProgressView!
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
