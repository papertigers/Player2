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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    func configure(withPresenter presenter: TwitchCellPresentable) {
        //backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageWhenAncestorFocused = true
        
        title.backgroundColor = .clear
        title.text = presenter.title
        
        self.imageView.kf.cancelDownloadTask()
        let url = URL(string: presenter.icon)!
        self.imageView.kf.setImage(with: url)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if(context.nextFocusedView == self){
            coordinator.addCoordinatedAnimations({ [weak title] in
                let bottom = self.imageView.focusedFrameGuide.layoutFrame.maxY
                title?.frame = CGRect(x: 0, y: bottom, width: 272, height: 40)
                title?.textColor = .white

            }, completion: nil)
        }
        if (context.previouslyFocusedView == self) {
            coordinator.addCoordinatedAnimations({ [weak title] in
                title?.frame = CGRect(x: 0, y: self.imageView.frame.height, width: 272, height: 40)
                title?.textColor = .black
            }, completion: nil)
        }
    }
}
