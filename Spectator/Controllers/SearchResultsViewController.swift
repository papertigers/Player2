//
//  SearchResultsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class SearchResultsViewController<A: TwitchAdapter>: UIViewController, UICollectionViewDelegate {
    var containerViewController: UIView!
    //var collectionView: UICollectionView!
    
    var adapter: A!
    var searchType: TwitchSearch!
    var titleBar: TitleBar?
    

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerViewController = UIView()
        self.containerViewController.translatesAutoresizingMaskIntoConstraints = false
        self.containerViewController.backgroundColor = .red
        self.view.addSubview(self.containerViewController)
        setupConstraints()
        return

        
        
        //collectionView.delegate = self
//        titleBar?.titleLabel.text = "Search Results"
//        titleBar?.searchBar.isHidden = true
//        titleBar?.reloadButton.isHidden = true
        
        //setupView(withConfig: GameCollectionViewConfig())
    }
    
    func setupConstraints() {
        let views = ["titleBar": containerViewController]
        let titleBarHorizontalPin = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleBar]|", options: [], metrics: nil, views: views)
        let titleBarVerticalPin = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleBar(100)]", options: [], metrics: nil, views: views)
        var titleBarConstraints = [NSLayoutConstraint]()
        titleBarConstraints += titleBarVerticalPin
        titleBarConstraints += titleBarHorizontalPin
        self.view.addConstraints(titleBarConstraints)
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
