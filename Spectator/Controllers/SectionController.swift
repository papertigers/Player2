//
//  SectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/20/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

protocol CollectionViewConfig {
    var itemSize: CGSize { get }
}

struct GameCollectionViewConfig: CollectionViewConfig {
    let itemSize = CGSize(width: 272, height: 420)
}

struct StreamCollectionViewConfig: CollectionViewConfig {
    let itemSize = CGSize(width: 320, height: 260)
}


class SectionController: UICollectionViewController {
    var titlebar: UIView!
    
    
    func setupView(withConfig config: CollectionViewConfig) {
        
        //Test titlebar
        titlebar = UIView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        titlebar.backgroundColor = .red
        view.addSubview(titlebar)
        //view.bringSubview(toFront: titlebar)
        let title = UILabel()
        title.text = "Top Games"
        title.textColor = .black
        titlebar.addSubview(title)
//        let centerX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: titlebar, attribute: .centerX, multiplier: 1, constant: 0)
//        let centerY = NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: titlebar, attribute: .centerY, multiplier: 1, constant: 0)
//        let titleWidth = NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil,
//                                            attribute: .notAnAttribute, multiplier: 1, constant: 300)
//        title.addConstraints([centerX])
        
        //Set collectionview inset
        collectionView?.contentInset = UIEdgeInsetsMake(titlebar.frame.height, 0, 0, 0)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = config.itemSize
        layout.minimumInteritemSpacing = 30.0
        layout.minimumLineSpacing = 80.0
        layout.sectionInset = UIEdgeInsetsMake(50, 50.0, 30.0, 50.0)
        collectionView?.collectionViewLayout = layout
        collectionView?.register(cellType: TwitchCell.self)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
