//
//  FeaturedStreamsSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/29/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class FeaturedStreamsSectionController: UICollectionViewController, TwitchSectionController {
    var adapter: FeaturedStreamsAdapter!
    var game: TwitchGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = FeaturedStreamsAdapter(collectionView: collectionView!)
        setupCollectionView(withAdapter: adapter)
        adapter.loadStreams()
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
