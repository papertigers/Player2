//
//  FeaturedStreamsAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 11/29/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Dwifft_tvOS
import Kingfisher
import OrderedSet

class FeaturedStreamsAdapter: NSObject, TwitchAdapter, TwitchSearchAdapter, UICollectionViewDataSource {
    let adapterType: TwitchAdapterType
    let searchQuery: String
    internal weak var collectionView: UICollectionView?
    fileprivate var diffCalculator: CollectionViewDiffCalculator<TwitchStream>?
    var items = OrderedSet<TwitchStream>() {
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
        self.diffCalculator = CollectionViewDiffCalculator<TwitchStream>(collectionView: collectionView)
        super.init()
    }
    
    func loadStreams() {
        api.featuredStreams(100, offset: offset) { [weak self] res in
            guard let streams = res.results else {
                self?.displayErrorView(error: res.error?.localizedDescription ?? "Failed to load.")
                return print("Couldn't load streams: \(String(describing: res.error))")
            }
            self?.updateDatasource(withArray: streams)
        }
    }
    
    func searchStreams() {
        api.searchStreams(limit, offset: offset, query: self.searchQuery) { [weak self] res in
            guard let results = res.results else {
                if let error = res.error {
                    switch error {
                    case TwitchService.TwitchError.noSearchResults:
                        self?.displayErrorView(error: "No results for \"\(self?.searchQuery ?? "search term")\"")
                    default:
                        self?.displayErrorView(error: res.error?.localizedDescription ?? "Failed to load.")
                    }
                } else {
                    self?.displayErrorView(error: "Failed to load search results from Twitch.")
                }
                
                return print("Failed to get search results")
            }
            //v5 does not paginate results
            self?.finished = true
            if (results.count == 0) {
                self?.displayErrorView(error: "No results for \"\(self?.searchQuery ?? "the query")\"")
            }
            self?.updateDatasource(withArray: results)
        }
    }
    
    func load() {
        if (finished) { return }
        switch adapterType {
        case .Normal:
            return loadStreams()
        case .Search:
            return searchStreams()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TwitchCell
        let viewModel = TwitchFeaturedStreamViewModel(stream: items[indexPath.row])
        cell.configure(withPresenter: viewModel)
        return cell
    }
}


extension FeaturedStreamsAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].preview.large) }
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].preview.large) }
        ImagePrefetcher(urls: urls).stop()
    }
}
