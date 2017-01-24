//
//  AdapterProtocols.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import OrderedSet
import Kingfisher

struct P2ImageCache {
    enum CellType: String {
        case GameCell = "GameCell"
        case StreamCell = "StreamCell"
    }
    
    static let StreamCellCache = ImageCache(name: CellType.StreamCell.rawValue)
    static let GameCellCache = ImageCache(name: CellType.GameCell.rawValue)
}

enum TwitchAdapterType {
    case Normal
    case Search
}

protocol TwitchAdapter: class {
    associatedtype Item: Hashable
    var offset: Int { get set }
    var limit: Int { get }
    var items: OrderedSet<Item> { get set}
    var finished: Bool { get set }
    var collectionView: UICollectionView? { get }
    func load()
}

extension TwitchAdapter {
    var limit: Int {
        return 100
    }
    
     func updateDatasource(withArray array: [Item]) {
        if (array.count == 0) {
            self.finished = true
            return
        }
        self.items += array
        self.offset += limit
    }
    
     func reload() {
        removeErrorView()
        if (items.count > 0) {
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top, animated: true)
        }
        self.offset = 0
        self.finished = false
        self.items = []
        self.load()
        
    }
    
    func displayErrorView(error: String = "Failed to load", withDelegate delegate: AdapterErrorViewDelegate? = nil) {
        guard let collectionView = collectionView else {
            return
        }
        guard let errorView = Bundle.main.loadNibNamed("AdapterErrorView", owner: nil, options: nil)?.first as? AdapterErrorView else {
            return
        }
        errorView.configure(error: error)
        errorView.delegate = delegate
        collectionView.backgroundView = errorView
    }
    
    func removeErrorView() {
        collectionView?.backgroundView = nil
    }
}

// Handy function to generate a new datasource that can be used to Diff
extension Array where Element: Hashable {
    func appendAndDeduplicate(to array: [Element]) -> [Element] {
        let dedup = self.filter { !array.contains($0) }
        return Array([dedup, array].joined())
    }
}

protocol TwitchSearchItem {
    
}

protocol TwitchSearchAdapter: TwitchAdapter {
    var adapterType: TwitchAdapterType { get }
    var searchQuery: String { get }
    func load()
}

