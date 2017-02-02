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
    var collectionView: UICollectionView! { get }
    var titleBar: TitleBar? { get }
}

extension TwitchSectionController where Self: UIViewController {
    func setupView(withConfig config: CollectionViewConfig) {
        // Background
        collectionView.backgroundColor = ColorScheme.backgroundColor
        // Setup new flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = config.itemSize
        layout.minimumInteritemSpacing = 50.0
        layout.minimumLineSpacing = 100.0
        
        // Setup the collectionview
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsetsMake(60, 90, 60, 90)
        collectionView.register(cellType: TwitchCell.self)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.showsVerticalScrollIndicator = false  //tvOS 10.2 seems to display this by default
    }
    
    func setupCollectionView(withAdapter adapter: Adapter) {
        collectionView.dataSource = adapter
        collectionView.prefetchDataSource = adapter
        collectionView.isPrefetchingEnabled = true
    }
}
