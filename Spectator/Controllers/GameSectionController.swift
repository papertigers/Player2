//
//  GameSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/10/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class GameSectionController: SectionController, UICollectionViewDelegateFlowLayout {
    var gamesAdapter: GamesAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(withConfig: GameCollectionViewConfig())
        gamesAdapter = GamesAdapter(collectionView: collectionView!)
        collectionView!.dataSource = gamesAdapter
        gamesAdapter.loadGames()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(gamesAdapter.games[indexPath.row])
        performSegue(withIdentifier: "ShowChannels", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChannels" {
            let channelsVC = segue.destination as! StreamSectionController
            channelsVC.game = gamesAdapter.games[(sender as! NSIndexPath).row]
        }
    }
}

