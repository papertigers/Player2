//
//  FeaturedStreamsSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/29/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class FeaturedStreamsSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController, TitleBarDelegate {
    var adapter: FeaturedStreamsAdapter!
    
    var titleBar: TitleBar?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = "Featured Streams"
        titleBar?.setSearchBar(placeholder: "Search Streams")
        titleBar?.delegate = self
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = FeaturedStreamsAdapter(collectionView: collectionView!)
        setupCollectionView(withAdapter: adapter)
        adapter.load()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(adapter.items[indexPath.row])
        performSegue(withIdentifier: "showstream", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showstream" {
            let streamVC = segue.destination as! StreamController
            streamVC.stream = adapter?.items[(sender as! NSIndexPath).row]
        }
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
            
        }
    }
    
    func handleReload() {
        adapter.reload()
    }
}

extension FeaturedStreamsSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.load()
        }
    }
}

extension FeaturedStreamsSectionController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let searchBar = self.titleBar?.searchBar, let parent = self.parent as? TabBarViewController {
            if (searchBar.isFocused) {
                parent.displayTabBarFocus = true
                environments = environments + [parent]
            }
        }
        if let bar = self.titleBar {
            environments = environments + [bar]
        }
        return environments
    }
}
