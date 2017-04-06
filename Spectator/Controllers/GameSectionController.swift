//
//  GameSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 11/10/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import COLORAdFramework

class GameSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController, TitleBarDelegate {
    var adapter: GamesAdapter!
    var titleBar: TitleBar?
    var shouldFocusTitleBar = false
    var ad: UIViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = "Games"
        titleBar?.setSearchBar(placeholder: "Search Games")
        titleBar?.delegate = self
        setupView(withConfig: GameCollectionViewConfig())
        adapter = GamesAdapter(collectionView: collectionView!, type: .Normal)
        setupCollectionView(withAdapter: adapter)
        adapter?.safeLoad()
        
        COLORAdController.sharedAdController().adViewController(forPlacement: "VideoStart", withCompletion: { (vc , error) in
            guard let vc = vc else {
                print("Failed to initialize ad view controller")
                return
            }
            
            vc.addCompletionHandler({ (video) in
                self.dismiss(animated: true, completion: nil)
                self.ad = nil
            })
            
            self.ad = vc
            
        }, expirationHandler: { (expiredVc) in
            self.ad = nil
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(adapter.items[indexPath.row])
        if let adVC = self.ad {
            self.present(adVC, animated: false)
        } else {
            performSegue(withIdentifier: "showchannels", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showchannels" {
            let channelsVC = segue.destination as! StreamSectionController
            channelsVC.game = adapter.items[(sender as! NSIndexPath).row].name
        }
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
        }
    }
    
    func handleReload() {
        adapter.safeReload()
    }
    
    func handleSearch(_ text: String) {
        let vc = SearchResultsViewController<GamesAdapter>.init(query: text, type: .games)
        present(vc, animated: true)
    }
}

extension GameSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.safeLoad()
        }
    }
}


extension GameSectionController {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // Hack to find out if the focused item is in the collectionView
        if let _ = context.nextFocusedView as? TwitchCell {
            self.shouldFocusTitleBar = true
        } else {
            self.shouldFocusTitleBar = false
        }
        super.didUpdateFocus(in: context, with: coordinator)
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {

        var environments = [UIFocusEnvironment]()
        if let parent = self.parent as? TabBarViewController {
            if (shouldFocusTitleBar) {
                if let titleBar = titleBar {
                    environments = environments + [titleBar]
                }
            }
            environments = environments + [parent.tabBar]
        }
        environments = environments + [containerViewController]
        return environments
    }
}

