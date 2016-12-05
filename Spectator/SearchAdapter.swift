//
//  SearchAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 12/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Dwifft_tvOS
import Kingfisher
import OrderedSet

class GamesSearchAdapter: NSObject, TwitchAdapter, TwitchSearchAdapter, UICollectionViewDataSource {
    private let api = TwitchService()
    weak var collectionView: UICollectionView?
    var searchQuery: String = ""
    fileprivate var diffCalculator: CollectionViewDiffCalculator<TwitchGame>?
    var items = OrderedSet<TwitchGame>() {
        didSet {
            print(items)
            self.diffCalculator?.rows = Array(items)
        }
    }
    var offset = 0
    var finished = false
    
    override init() {
        super.init()
    }
    
    convenience init(_ searchQuery: String) {
        self.init()
        self.searchQuery = searchQuery
    }
    
    func setup(collectionView: UICollectionView, type: TwitchSearch, query: String) {
        self.collectionView = collectionView
        self.diffCalculator = CollectionViewDiffCalculator<TwitchGame>(collectionView: collectionView)
        self.searchQuery = query
    }
    
    func load() {
        api.searchGames(query: self.searchQuery) { [weak self] res in
            guard let results = res.results else {
                return print("Failed to get search results")
            }
            self?.updateDatasource(withArray: results)
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

extension GamesSearchAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].box.large) }
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].box.large) }
        ImagePrefetcher(urls: urls).stop()
    }
}
