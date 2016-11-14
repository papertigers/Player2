//
//  ChannelsAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher

class ChannelsAdapter: NSObject, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    internal var channels = [TwitchStream]()
    private let api = TwitchService()
    
    let reuseIdentifier = "ChannelCell"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func loadChannels(game: TwitchGame) {
        api.streamsForGame(100, offset: 0, game: game) { [weak self] res in
            guard let channels = res.results else {
                return print("Couldn't load channels: \(res.error)") //print error
            }
            self?.channels = channels
            self?.collectionView?.reloadData() // Only for testing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChannelCell
        cell.imageView.kf.cancelDownloadTask() // Cancel download if in progress
        let channel = channels[indexPath.row]
        let url = URL(string: channel.preview["large"]!)!
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
