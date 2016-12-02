//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class StreamSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController {
    var adapter: ChannelsAdapter!
    var game: TwitchGame!
    
    var titleBar: TitleBar?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = game.name
        self.titleBar?.searchBar.isHidden = true
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = ChannelsAdapter(collectionView: collectionView!, game: self.game)
        Flurry.logEvent("Get Streams", withParameters: ["Game": game.name])
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
}

extension StreamSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.load()
        }
    }
}

extension StreamSectionController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let searchBar = self.titleBar?.searchBar, let parent = self.parent as? TabBarViewController {
            if (searchBar.isFocused) {
                parent.displayTabBarFocus = true
                environments = environments + [parent]
            }
        }
        environments = environments + [collectionView]
        return environments
    }
}
