//
//  GameSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/10/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class GameSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController {
    var adapter: GamesAdapter!
    var titleBar: TitleBar?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = "Top Games"
        self.titleBar?.setSearchBar(placeholder: "Search Games")
        setupView(withConfig: GameCollectionViewConfig())
        adapter = GamesAdapter(collectionView: collectionView!)
        setupCollectionView(withAdapter: adapter)
        adapter?.load()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(adapter.items[indexPath.row])
        performSegue(withIdentifier: "showchannels", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showchannels" {
            let channelsVC = segue.destination as! StreamSectionController
            channelsVC.game = adapter.items[(sender as! NSIndexPath).row]
        }
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
            
        }
    }
}

extension GameSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.load()
        }
    }
}


extension GameSectionController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let searchBar = self.titleBar?.searchBar, let parent = self.parent as? TabBarViewController {
            if (searchBar.isFocused) {
               parent.displayTabBarFocus = true
                environments = environments + [parent]
            }
        }
        environments = environments + [containerViewController]
        return environments
    }
}
