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
        layout.itemSize = CGSize(width: 272, height: 430)
        layout.minimumInteritemSpacing = 30.0
        layout.minimumLineSpacing = 80.0
        layout.sectionInset = UIEdgeInsetsMake(50.0, 50.0, 30.0, 50.0)
        collectionView!.collectionViewLayout = layout
        collectionView!.register(TwitchCell.classForCoder(), forCellWithReuseIdentifier: "GameCell")
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(gamesAdapter.games[indexPath.row])
        performSegue(withIdentifier: "ShowChannels", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChannels" {
            let channelsVC = segue.destination as! StreamSectionController
            channelsVC.game = gamesAdapter.games[(sender as! NSIndexPath).row]
        }
    }
}

