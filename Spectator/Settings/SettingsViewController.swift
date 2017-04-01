//
//  SettingsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 4/1/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let general =  [Settings.login]
    let experience = [Settings.theme]
    let about = [Settings.acknowledgements]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Settings TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Testing"
        return cell
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

// MARK: - Settings Enum

enum Settings {
    case login
    case theme
    case acknowledgements
}

protocol SettingsPresentable {
    var text: String { get }
    var subText: String { get }
}

extension Settings: SettingsPresentable {
    var text: String {
        switch self {
        case .login:
            return "Login"
        case .theme:
            return "Theme"
        case .acknowledgements:
            return "Acknowledgements"
        }
    }
    var subText: String {
        switch self {
        case .login:
            return "(Coming Soon)"
        case .theme:
            return "Default"
        case .acknowledgements:
            return ""
        }
    }
}
