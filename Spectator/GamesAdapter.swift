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

class GamesAdapter: NSObject, TwitchAdapter, TwitchSearchAdapter, UICollectionViewDataSource {
    let adapterType: TwitchAdapterType
    let searchQuery: String
    internal weak var collectionView: UICollectionView?
    fileprivate var diffCalculator: CollectionViewDiffCalculator<TwitchGame>?
    var items = OrderedSet<TwitchGame>() {
        didSet {
            self.diffCalculator?.rows = Array(items)
            if (collectionView?.backgroundView != nil) { self.removeErrorView() }
        }
    }
    private let api = TwitchService()
    var offset = 0
    var finished = false
    
    init(collectionView: UICollectionView, type: TwitchAdapterType, query: String = "") {
        self.adapterType = type
        self.searchQuery = query
        self.collectionView = collectionView
        self.diffCalculator = CollectionViewDiffCalculator<TwitchGame>(collectionView: collectionView)
        super.init()
    }
    
    func loadGames() {
        api.getTopGames(limit, offset: offset) { [weak self] res in
            guard let games = res.results else {
                self?.displayErrorView(error: res.error?.localizedDescription ?? "Failed to load.")
                return print("Failed to get top games")
            }
            if let strongSelf = self {
                if (games.count < strongSelf.limit) {
                    strongSelf.finished = true
                }
            }
            if (games.count == 0) {
                self?.displayErrorView(error: "Twitch is experiencing an issue, please try to reload")
            }
            self?.updateDatasource(withArray: games)
        }
    }
    
    func searchGames() {
        api.searchGames(limit, offset: offset, query: self.searchQuery) { [weak self] res in
            guard let results = res.results else {
                self?.displayErrorView(error: res.error?.localizedDescription ?? "Failed to load.")
                return print("Failed to get search results")
            }
            if (results.count == 0) {
                self?.finished = true
                self?.displayErrorView(error: "No results for \"\(self?.searchQuery ?? "search term")\"")
            }
            self?.updateDatasource(withArray: results)
        }
    }
    
    func load() {
        if (finished) { return }
        switch adapterType {
        case .Normal:
            return loadGames()
        case .Search:
            return searchGames()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diffCalculator?.rows.count ?? 0
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
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].box.large) }
        ImagePrefetcher(urls: urls).stop()
    }
}
