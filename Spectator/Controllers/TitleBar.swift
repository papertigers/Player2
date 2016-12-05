//
//  TitleBar.swift
//  Player2
//
//  Created by Michael Zeller on 12/1/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

protocol TitleBarDelegate {
    func handleReload()
    func handleSearch(_ text: String)
}

extension TitleBarDelegate {
    func handleSearch(_ text: String) {
        // Override to handle searching
        // Swift protocols cant have optional functions
        // unless they are @objc
    }
}

class TitleBar: UIViewController {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBAction func reloadPressed(_ sender: Any) {
        self.delegate?.handleReload()
    }
    
    var delegate: TitleBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.titleBarBackgroundColor
        self.titleLabel.textColor = ColorScheme.titleBarTextColor
        self.reloadButton.tintColor = ColorScheme.unselectedTextColor
        self.setSearchBar(placeholder: "Search")
        self.searchBar.delegate = self
    }
    
    func setSearchBar(placeholder text: String) {
        self.searchBar.attributedPlaceholder = NSAttributedString(string: text,
                           attributes:[NSForegroundColorAttributeName: ColorScheme.titleBarTextColor])
    }
}

extension TitleBar: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.characters.count > 0 else {
            return
        }
        self.delegate?.handleSearch(text)
        //self.searchBar.text = nil
    }
}

extension TitleBar {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [searchBar, reloadButton]
    }
}
