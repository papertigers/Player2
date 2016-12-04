//
//  SearchResultsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, TwitchSectionController {
    @IBOutlet weak var containerViewController: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleBar: TitleBar?
    
    convenience init() {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        titleBar?.titleLabel.text = "Search Results"
        titleBar?.searchBar.isHidden = true
        titleBar?.reloadButton.isHidden = true
        setupView(withConfig: GameCollectionViewConfig())
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
