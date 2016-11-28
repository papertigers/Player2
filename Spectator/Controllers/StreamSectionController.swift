//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class StreamSectionController: SectionController {
    var channelsAdapter: ChannelsAdapter!
    var game: TwitchGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(withConfig: StreamCollectionViewConfig())
        channelsAdapter = ChannelsAdapter(collectionView: collectionView!)
        collectionView!.dataSource = channelsAdapter
        collectionView!.prefetchDataSource = channelsAdapter
        collectionView!.isPrefetchingEnabled = true

        channelsAdapter.loadChannels(game: self.game)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(channelsAdapter.streams[indexPath.row])
        performSegue(withIdentifier: "ShowStream", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStream" {
            let streamVC = segue.destination as! StreamController
            streamVC.stream = channelsAdapter.streams[(sender as! NSIndexPath).row]
        }
    }
}
