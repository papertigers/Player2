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

class SearchAdapter<T: TwitchSearchItem>: NSObject, TwitchAdapter where T: Hashable  {
    private let api = TwitchService()
    weak var collectionView: UICollectionView?
    let searchType: TwitchSearch
    let searchQuery: String
    var items = OrderedSet<T>()
    var offset = 0
    var finished = false
    
    init(collectionView: UICollectionView, type: TwitchSearch, query: String) {
        self.collectionView = collectionView
        self.searchType = type
        self.searchQuery = query
        super.init()
    }
    
    func load() {
        api.search(type: self.searchType, query: self.searchQuery) { res in
            guard let results = res.results else {
                return print("Failed to get search results")
            }
            print(results)
        }
    }
}
