//
//  File.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher

typealias TwitchCellPresentable = ImagePresentable & TextPresentable

class TwitchCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var itemStack: UIStackView!
    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    static let kITEMSPACING: CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    func configure(withPresenter presenter: TwitchCellPresentable) {
        //backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        let imageviewConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: presenter.iconMultiplier, constant: 0)
        imageView.addConstraint(imageviewConstraint)
        itemStack.layoutIfNeeded()
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageWhenAncestorFocused = true
        
        title.backgroundColor = .clear
        title.text = presenter.title
        
        subTitle.backgroundColor = .clear
        subTitle.text = presenter.subTitle
        
        self.imageView.kf.cancelDownloadTask()
        let url = URL(string: presenter.icon)!
        self.imageView.kf.setImage(with: url)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if(context.nextFocusedView == self){
            coordinator.addCoordinatedAnimations({ [weak title, weak subTitle, weak labelStack] in
                let bottom = self.imageView.focusedFrameGuide.layoutFrame.maxY
                if let labelStack = labelStack {
                    labelStack.frame = CGRect(x: 0, y: bottom + TwitchCell.kITEMSPACING, width: labelStack.frame.width, height: labelStack.frame.height)
                    title?.textColor = .white
                    subTitle?.textColor = .white

                }
                    }, completion: nil)
        }
        if (context.previouslyFocusedView == self) {
            coordinator.addCoordinatedAnimations({ [weak title, weak subTitle, weak labelStack] in
                if let labelStack = labelStack {
                    labelStack.frame = CGRect(x: 0, y: self.imageView.frame.height + TwitchCell.kITEMSPACING,
                                              width: labelStack.frame.width, height: labelStack.frame.height)
                    title?.textColor = .black
                    subTitle?.textColor = .black
                }
            }, completion: nil)
        }
    }
}
