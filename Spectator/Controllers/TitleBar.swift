//
//  TitleBar.swift
//  Player2
//
//  Created by Michael Zeller on 12/1/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

class TitleBar: UIViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.titleBarBackgroundColor
        self.titleLabel.textColor = ColorScheme.titleBarTextColor
        self.reloadButton.tintColor = ColorScheme.unselectedTextColor
        self.setSearchBar(placeholder: "Search")
    }
    
    func setSearchBar(placeholder text: String) {
        self.searchBar.attributedPlaceholder = NSAttributedString(string: text,
                           attributes:[NSForegroundColorAttributeName: ColorScheme.titleBarTextColor])
    }
}
