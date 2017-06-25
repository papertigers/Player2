//
//  ChannelAdapter.swift
//  Player2
//
//  Created by Michael Zeller on 6/25/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import Dwifft_tvOS
import Kingfisher
import OrderedSet

class ChannelAdapter:  NSObject, TwitchAdapter, TwitchSearchAdapter, UICollectionViewDataSource {
    let adapterType: TwitchAdapterType
    let searchQuery: String
    internal weak var collectionView: UICollectionView?
    fileprivate var diffCalculator: CollectionViewDiffCalculator<TwitchChannel>?
    var items = OrderedSet<TwitchChannel>() {
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
        self.diffCalculator = CollectionViewDiffCalculator<TwitchChannel>(collectionView: collectionView)
        super.init()
    }
    
    func loadChannels() {
        api.getChannels(100, offset: offset) { [weak self] res in
            guard let channels = res.results else {
                self?.displayErrorView(error: res.error?.localizedDescription ?? "Failed to load.")
                return print("Couldn't load streams: \(String(describing: res.error))")
            }
            self?.updateDatasource(withArray: channels)
        }
    }
    
    func searchChannels() {

    }
    
    func load() {
        if (finished) { return }
        switch adapterType {
        case .Normal:
            return loadChannels()
        case .Search:
            return searchChannels()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TwitchCell
        let viewModel = TwitchChannelViewModel(channel: items[indexPath.row])
        cell.configure(withPresenter: viewModel)
        return cell
    }
}

extension ChannelAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].videoBanner ) }
        let urls: [URL] = []
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        //let urls: [URL] = indexPaths.flatMap { URL(string: items[$0.row].videoBanner) }
        let urls: [URL] = []
        ImagePrefetcher(urls: urls).stop()
    }
}
