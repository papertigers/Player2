//
//  ChannelSectionController.swift
//  Player2
//
//  Created by Michael Zeller on 6/25/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

class ChannelSectionController: UIViewController, UICollectionViewDelegate, TwitchSectionController, TitleBarDelegate {
    var adapter: ChannelAdapter!
    var titleBar: TitleBar?
    var shouldFocusTitleBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        titleBar?.titleLabel.text = "Channels"
        titleBar?.setSearchBar(placeholder: "Search Channels")
        titleBar?.delegate = self
        setupView(withConfig: StreamCollectionViewConfig())
        adapter = ChannelAdapter(collectionView: collectionView!, type: .Normal)
        setupCollectionView(withAdapter: adapter)
        adapter?.safeLoad()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewController: UIView!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showchannel", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
        }
        if segue.identifier == "showchannel"{
            let channelVC = segue.destination as! ChannelViewController
            channelVC.channel = adapter.items[(sender as! NSIndexPath).row]
        }
    }
    
    
    func handleReload() {
        adapter.safeReload()
    }
    
    func handleSearch(_ text: String) {
        //Do something
    }
}

extension ChannelSectionController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.safeLoad()
        }
    }
}

extension ChannelSectionController {
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
