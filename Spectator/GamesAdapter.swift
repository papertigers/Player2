//
//  GamesAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 11/13/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Dwifft_tvOS
import Kingfisher
import OrderedSet

class GamesAdapter: NSObject, TwitchAdapter, UICollectionViewDataSource {
    private weak var collectionView: UICollectionView?
    fileprivate var diffCalculator: CollectionViewDiffCalculator<TwitchGame>?
    var items = OrderedSet<TwitchGame>() {
        didSet {
            self.diffCalculator?.rows = Array(items)
        }
    }
    private let api = TwitchService()
    var offset = 0
    var finished = false
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.diffCalculator = CollectionViewDiffCalculator<TwitchGame>(collectionView: collectionView)
        super.init()
    }
    
    func load() {
        if (finished) { return }
        api.getTopGames(limit, offset: offset) { [weak self] res in
            guard let games = res.results else {
                return print("Failed to get games")
            }
            self?.updateDatasource(withArray: games)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TwitchCell
        let viewModel = TwitchGameViewModel(game: items[indexPath.row])
        cell.configure(withPresenter: viewModel)
        return cell
    }
}

extension GamesAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].box.large) }
        ImagePrefetcher(urls: urls).start()
        
    }
}
