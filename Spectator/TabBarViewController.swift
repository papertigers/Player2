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
        if (displayTabBarFocus) {
            print("value set to true")
            environments = environments + [self.tabBar]
            self.displayTabBarFocus = false
        }
        environments = environments + self.childViewControllers
        print(environments)
        return environments
    }
}
