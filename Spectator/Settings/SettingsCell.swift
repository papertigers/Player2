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
    @IBOutlet weak var subText: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(withPresenter presenter: SettingsPresentable) {
        self.settingLabel.text = presenter.text
        self.subText.text = presenter.subText
        self.settingLabel.textColor = .white
        self.subText.textColor = .lightGray
        self.layer.cornerRadius = 8
        self.selectionStyle = .none
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        var textColor: UIColor!
        var cellColor: UIColor!
        var transform: CGAffineTransform!
        var shadow = false
        
        if(context.nextFocusedView == self){
            textColor = .black
            cellColor = .white
            transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            shadow = true
            
        } else {
            textColor = .white
            cellColor = .clear
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            shadow = false
        }
        
        self.backgroundColor = cellColor
        settingLabel?.textColor = textColor
        coordinator.addCoordinatedAnimations({ [weak self] in
            let duration : TimeInterval = 0.5;
            UIView.animate(withDuration: duration, animations: {
                self?.transform = transform
                self?.setShadow(on: shadow)
            })
            }, completion: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (selected) {
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }, completion: { finished in
                // Set back
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
 
    func setShadow(on: Bool) {
        if on {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 1.0, height: 8.0)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 5.0
        } else {
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0.0
        }
    }
}
