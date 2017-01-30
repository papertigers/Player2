//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class StreamSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController, TitleBarDelegate {
    var adapter: ChannelsAdapter!
    var game: TwitchGame!
    
    var titleBar: TitleBar?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = game.name
        titleBar?.searchBar.isHidden = true
        titleBar?.delegate = self
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = ChannelsAdapter(collectionView: collectionView!, game: self.game)
        Flurry.logEvent("Get Streams", withParameters: ["Game": game.name])
        setupCollectionView(withAdapter: adapter)
        adapter.safeLoad()
        
        //Setup capture of menu button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMenuPress))
        tapGesture.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view.addGestureRecognizer(tapGesture)
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
        adapter.safeReload()
    }
    
    func handleMenuPress() {
        guard let rb = self.titleBar?.reloadButton, rb.isHidden == false else {
            return self.dismiss(animated: true)
        }
        if (rb.isFocused) {
           self.dismiss(animated: true)
        }
        // Try to focus on "Reload"
        self.setNeedsFocusUpdate()
    }
}

extension StreamSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.safeLoad()
        }
    }
}

extension StreamSectionController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let titleBar = titleBar {
            if let _ = UIScreen.main.focusedView as? TwitchCell {
                environments = environments + [titleBar, collectionView]
                return environments
            }
            environments = environments + [collectionView, titleBar]
        }
        return environments
    }
}
