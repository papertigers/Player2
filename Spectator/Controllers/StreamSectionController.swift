//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class StreamSectionController: UICollectionViewController, TwitchSectionController {
    var adapter: ChannelsAdapter!
    var game: TwitchGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = ChannelsAdapter(collectionView: collectionView!)
        setupCollectionView(withAdapter: adapter)
        adapter.loadChannels(game: self.game)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(adapter.streams[indexPath.row])
        performSegue(withIdentifier: "ShowStream", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStream" {
            let streamVC = segue.destination as! StreamController
            streamVC.stream = adapter?.streams[(sender as! NSIndexPath).row]
        }
    }
}
