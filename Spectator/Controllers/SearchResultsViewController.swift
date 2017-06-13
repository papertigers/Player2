//
//  SearchResultsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class SearchResultsViewController<T: TwitchSearchAdapter>: UIViewController, UICollectionViewDelegate, TwitchSectionController where T: UICollectionViewDataSource {
    var containerViewController: UIView!
    var collectionView: UICollectionView!
    
    var adapter: T!
    var searchType: TwitchSearch
    var titleBar: TitleBar?
    var searchQuery: String!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.searchType = .games
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.searchType = .games
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }


    convenience init(query: String, type: TwitchSearch) {
        self.init(nibName: nil, bundle: nil)
        self.searchQuery = query
        self.searchType = type
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerViewController = UIView()
        self.view.addSubview(containerViewController)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        titleBar = storyboard.instantiateViewController(withIdentifier: "TitleBar") as? TitleBar
        if let titleBar = self.titleBar {
            self.addChildViewController(titleBar)
            self.containerViewController.addSubview(titleBar.view)
            self.containerViewController.translatesAutoresizingMaskIntoConstraints = false
            titleBar.didMove(toParentViewController: self)
        }
        
        let layout = UICollectionViewLayout()
        self.collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        

        collectionView.delegate = self
        self.view.addSubview(collectionView)
        
        setupConstraints()
        
        
        //collectionView.delegate = self
        titleBar?.titleLabel.text = "Search Results"
        titleBar?.searchBar.isHidden = true
        titleBar?.reloadButton.isHidden = true
        switch searchType {
        case .games:
            adapter = GamesAdapter.init(collectionView: collectionView, type: .Search, query: searchQuery) as! T
            setupView(withConfig: GameCollectionViewConfig())
        case .streams:
            adapter = FeaturedStreamsAdapter.init(collectionView: collectionView, type: .Search, query: searchQuery) as! T
            setupView(withConfig: StreamCollectionViewConfig())
        }
        
        collectionView.dataSource = adapter
        adapter.load()
    }
    
    func setupConstraints() {
        let views: [String:UIView] = ["titleBar": containerViewController, "collectionView": collectionView]
        let titleBarHorizontalPin = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleBar]|", options: [], metrics: nil, views: views)
        let titleBarVerticalPin = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleBar(120)]", options: [], metrics: nil, views: views)
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += titleBarVerticalPin
        allConstraints += titleBarHorizontalPin

        
        let collectionViewHorizontalPin = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views)
        let collectionViewVerticalPin = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleBar]-0-[collectionView]|", options: [], metrics: nil, views: views)
        allConstraints += collectionViewVerticalPin
        allConstraints += collectionViewHorizontalPin
        
        self.view.addConstraints(allConstraints)
        self.titleBar?.view.frame = CGRect(x: 0, y: 0, width: self.containerViewController.frame.size.width, height: self.containerViewController.frame.size.height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        switch self.searchType {
        case .games:
            let streamsVC = storyboard.instantiateViewController(withIdentifier: "Streams") as! StreamSectionController
            streamsVC.game = (adapter.items[indexPath.row] as! TwitchGame).name
            present(streamsVC, animated: true)
        case .streams:
            // Load the stream player here
            let streamVC = storyboard.instantiateViewController(withIdentifier: "StreamPlayer") as! StreamController
            streamVC.stream = adapter.items[indexPath.row] as! TwitchStream
            present(streamVC, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
            
        }
    }
 
    // Can't put this in an extension becuase @objc is not supported for generic classes
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == adapter.items.count - 1 ) {
            adapter.load()
        }
    }
}
