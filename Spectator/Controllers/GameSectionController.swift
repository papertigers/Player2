//
//  GameSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/10/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class GameSectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var gamesAdapter: GamesAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        gamesAdapter = GamesAdapter(collectionView: collectionView!)
        collectionView!.dataSource = gamesAdapter
        gamesAdapter.loadGames()
    }

    
    func setupView() {
        //navigationItem.title = "Top Games"
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 272, height: 380)
        layout.minimumInteritemSpacing = 50.0
        layout.minimumLineSpacing = 50.0
        layout.sectionInset = UIEdgeInsetsMake(100.0, 50.0, 30.0, 50.0)
        collectionView!.collectionViewLayout = layout
        collectionView!.register(GameCell.classForCoder(), forCellWithReuseIdentifier: "GameCell")
        collectionView!.collectionViewLayout.invalidateLayout()
    }
}
