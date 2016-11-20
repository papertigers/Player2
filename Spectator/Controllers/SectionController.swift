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
    let itemSize = CGSize(width: 272, height: 430)
}

struct StreamCollectionViewConfig: CollectionViewConfig {
    let itemSize = CGSize(width: 320, height: 180)
}

class SectionController: UICollectionViewController {
    func setupView(withConfig config: CollectionViewConfig) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = config.itemSize
        layout.minimumInteritemSpacing = 30.0
        layout.minimumLineSpacing = 80.0
        layout.sectionInset = UIEdgeInsetsMake(50.0, 50.0, 30.0, 50.0)
        collectionView!.collectionViewLayout = layout
        collectionView!.register(cellType: TwitchCell.self)
        collectionView!.collectionViewLayout.invalidateLayout()
    }
}
