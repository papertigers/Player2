//
//  NewSearchResultsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/18/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Alamofire

class NewSearchResultsViewController: UIViewController, UISearchBarDelegate {
    
    var gamesVC: GameSectionController!
    var searchRequest: Request?
    
    override func viewDidLoad() {
        self.view.backgroundColor = ColorScheme.backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let controller as GameSectionController:
            gamesVC = controller
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count < 3) { return }
        print(searchText)
    }
    
}
