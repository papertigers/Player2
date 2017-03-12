//
//  TabBarViewController.swift
//  Player2
//
//  Created by Michael Zeller on 12/2/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var displayTabBarFocus = false
    
//  This is for loading a Search Controller in swift.  Currently we manage search ourselves.  
//    override func viewWillAppear(_ animated: Bool) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let gs = sb.instantiateViewController(withIdentifier: "Games") as! GameSectionController
//        let resultsController = gs
//        let searchController = UISearchController(searchResultsController: resultsController)
//        //searchController.searchResultsUpdater = resultsController
//        
//        searchController.obscuresBackgroundDuringPresentation = true
//        searchController.hidesNavigationBarDuringPresentation = false
//        
//        searchController.searchBar.placeholder = "Search Game"
//        
//        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
//        searchController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 3)
//        var tbViewControllers = self.viewControllers
//        tbViewControllers?.append(searchController)
//        self.viewControllers = tbViewControllers
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

         //Do any additional setup after loading the view.
//        for item in self.preferredFocusEnvironments {
//            print(item.debugDescription)
//        }
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TabBarViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let selected = self.selectedViewController {
            environments = environments + [selected]
        }
        environments = environments + [self.tabBar]
        return environments
    }
}
