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


// Instead of subclassing lets use POP
typealias Adapter = UICollectionViewDataSource & UICollectionViewDataSourcePrefetching
protocol TwitchSectionController {

}

extension TwitchSectionController where Self: UICollectionViewController {
    func setupView(withConfig config: CollectionViewConfig) {
        // Background
        self.view.backgroundColor = ColorScheme.backgroundColor
        // Setup new flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = config.itemSize
        layout.minimumInteritemSpacing = 50.0
        layout.minimumLineSpacing = 100.0
        
        // Setup the collectionview
        collectionView?.collectionViewLayout = layout
        collectionView?.contentInset = UIEdgeInsetsMake(60, 90, 60, 90)
        collectionView?.register(cellType: TwitchCell.self)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView(withAdapter adapter: Adapter) {
        collectionView?.dataSource = adapter
        collectionView?.prefetchDataSource = adapter
        collectionView?.isPrefetchingEnabled = true
    }
}
