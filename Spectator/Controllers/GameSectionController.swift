//
//  GameSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/10/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class GameSectionController: UICollectionViewController, TwitchSectionController {
    var adapter: GamesAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(withConfig: GameCollectionViewConfig())
        adapter = GamesAdapter(collectionView: collectionView!)
        setupCollectionView(withAdapter: adapter)
        adapter?.loadGames()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(adapter.games[indexPath.row])
        performSegue(withIdentifier: "ShowChannels", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChannels" {
            let channelsVC = segue.destination as! StreamSectionController
            channelsVC.game = adapter.games[(sender as! NSIndexPath).row]
        }
    }
}

