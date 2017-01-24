//
//  AdapterErrorView.swift
//  Player2
//
//  Created by Michael Zeller on 1/23/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit

protocol AdapterErrorViewDelegate: class {
    func retry()
}

class AdapterErrorView: UIView {
    weak var delegate: AdapterErrorViewDelegate?
    
    @IBOutlet weak var errorMessage: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func configure(error: String) {
        errorMessage.text = error
    }
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        delegate?.retry()
    }
}
