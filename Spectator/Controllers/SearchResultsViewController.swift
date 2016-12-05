//
//  SearchResultsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class SearchResultsViewController<T: TwitchSearchItem>: UIViewController,  TwitchSectionController, UICollectionViewDelegate where T: Hashable {
    var containerViewController: UIView!
    var collectionView: UICollectionView!
    
    var adapter: SearchAdapter<T>!
    var searchType: TwitchSearch!
    var titleBar: TitleBar?
    

    convenience init(query: String) {
        self.init(nibName: nil, bundle: nil)

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
        
        adapter = SearchAdapter<T>.init(collectionView: collectionView, type: TwitchSearch.games, query: "over")
        self.view.addSubview(collectionView)
        
        setupConstraints()
        
        
        //collectionView.delegate = self
        titleBar?.titleLabel.text = "Search Results"
        titleBar?.searchBar.isHidden = true
        titleBar?.reloadButton.isHidden = true
        
        setupView(withConfig: GameCollectionViewConfig())
        adapter.load()
    }
    
    func setupConstraints() {
        let views = ["titleBar": containerViewController, "collectionView": collectionView]
        let titleBarHorizontalPin = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleBar]|", options: [], metrics: nil, views: views)
        let titleBarVerticalPin = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleBar(100)]", options: [], metrics: nil, views: views)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "titlebar"{
            titleBar = segue.destination as? TitleBar
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
