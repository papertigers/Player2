//
//  SettingsCell.swift
//  Player2
//
//  Created by Michael Zeller on 4/1/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit
import Reusable

class SettingsCell: UITableViewCell, NibReusable {
    @IBOutlet weak var settingLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        var textColor: UIColor!
        var cellColor: UIColor!
        var transform: CGAffineTransform!
        
        if(context.nextFocusedView == self){
            textColor = .black
            cellColor = .white
            transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            
        } else {
            textColor = .white
            cellColor = .clear
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        self.backgroundColor = cellColor
        settingLabel?.textColor = textColor
        coordinator.addCoordinatedAnimations({ [weak self] in
            let duration : TimeInterval = 0.5;
            UIView.animate(withDuration: duration, animations: {
                self?.transform = transform
            })
            }, completion: nil)
        
    }
    
}
