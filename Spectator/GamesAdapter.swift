//
//  GamesAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 11/13/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher

class GamesAdapter: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    internal var games = [TwitchGame]()
    private let api = TwitchService()
    
    let reuseIdentifier = "GameCell"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func loadGames(offset: Int = 0) {
        api.getTopGames(100, offset: offset) { [weak self] res in
            guard let games = res.results else {
                return print("Failed to get games")
            }
            
            self?.games = games
            self?.collectionView?.reloadData() // Only for testing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GameCell
        cell.imageView.kf.cancelDownloadTask() // Cancel download if in progress
        let game = games[indexPath.row]
        let url = URL(string: game.box(.Large)!)
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
