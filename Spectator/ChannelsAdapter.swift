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
    internal var streams = [TwitchStream]()
    private let api = TwitchService()
        
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func loadChannels(game: TwitchGame) {
        api.streamsForGame(100, offset: 0, game: game) { [weak self] res in
            guard let streams = res.results else {
                return print("Couldn't load channels: \(res.error)") //print error
            }
            self?.streams = streams
            self?.collectionView?.reloadData() // Only for testing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TwitchCell
        let viewModel = TwitchStreamViewModel(stream: streams[indexPath.row])
        cell.configure(withPresenter: viewModel)
        return cell
    }
}

extension ChannelsAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap {
            guard let url = streams[$0.row].preview["large"] else {
                return nil
            }
            return URL(string: url)
        }
        ImagePrefetcher(urls: urls).start()
        
    }
}
