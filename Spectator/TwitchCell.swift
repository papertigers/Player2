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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        itemStack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageviewConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width,
                                                     multiplier: presenter.iconMultiplier, constant: 0)
        imageView.addConstraint(imageviewConstraint)
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageWhenAncestorFocused = true
        
        title.backgroundColor = .clear
        title.text = presenter.title
        title.textColor = ColorScheme.unselectedTextColor
        
        subTitle.backgroundColor = .clear
        subTitle.text = presenter.subTitle
        subTitle.textColor = ColorScheme.unselectedTextColor
        
        self.imageView.kf.cancelDownloadTask()
        let url = URL(string: presenter.icon)!
        self.imageView.kf.setImage(with: url, placeholder: UIImage(named: presenter.placeholder), options: [.targetCache(presenter.cache)])
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        var color: UIColor!
        var adjustY: CGFloat!
        var transform: CGAffineTransform!

        if(context.nextFocusedView == self){
            color = .white
            adjustY = self.imageView.focusedFrameGuide.layoutFrame.maxY - self.imageView.frame.maxY + TwitchCell.kITEMSPACING
            transform = CGAffineTransform(translationX: 0, y: adjustY)

        } else {
            color = ColorScheme.unselectedTextColor
            adjustY = 0
            transform = CGAffineTransform.identity
        }
        
        coordinator.addCoordinatedAnimations({ [weak title, weak subTitle, weak labelStack] in
            if let labelStack = labelStack {
                labelStack.transform = transform
                title?.textColor = color
                subTitle?.textColor = color
                
            }
        }, completion: nil)

    }
}
