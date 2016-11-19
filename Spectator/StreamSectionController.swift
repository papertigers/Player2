//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class StreamSectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var channelsAdapter: ChannelsAdapter!
    var game: TwitchGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        channelsAdapter = ChannelsAdapter(collectionView: collectionView!)
        collectionView!.dataSource = channelsAdapter
        channelsAdapter.loadChannels(game: self.game)
    }
    
    
    func setupView() {
        //navigationItem.title = "Top Games"
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 320, height: 180)
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 80.0
        layout.sectionInset = UIEdgeInsetsMake(50.0, 50.0, 30.0, 50.0)
        collectionView!.collectionViewLayout = layout
        collectionView!.register(TwitchCell.classForCoder(), forCellWithReuseIdentifier: "ChannelCell")
        collectionView!.collectionViewLayout.invalidateLayout()
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
