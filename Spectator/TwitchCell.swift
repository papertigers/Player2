//
//  File.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher

typealias TwitchCellPresentable = ImagePresentable // <ImagePresentable, LablePresentable>

class TwitchCell: UICollectionViewCell, Reusable {
    let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageWhenAncestorFocused = true
        addSubview(imageView)
    }
    
    func configure(withPresenter presenter: TwitchCellPresentable) {
        self.imageView.kf.cancelDownloadTask()
        let url = URL(string: presenter.icon)!
        self.imageView.kf.setImage(with: url)
    }
}
