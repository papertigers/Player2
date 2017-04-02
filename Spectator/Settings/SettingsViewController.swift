//
//  SettingsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 4/1/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit
import Reusable

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    enum Section: Int {
        case general = 0, experience, about
    }
    
    let settings: [Section: [Settings]] = [
        .general: [Settings.login],
        .experience: [Settings.quality, Settings.theme],
        .about: [Settings.acknowledgements]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: SettingsCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Settings TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[Section(rawValue: section)!]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        switch Section(rawValue: section)! {
        case .general:
            title = "General"
        case .experience:
            title = "Experience"
        case .about:
            title = "About"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .gray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SettingsCell
        let setting = self.settings[Section(rawValue: indexPath.section)!]![indexPath.row]
        cell.configure(withPresenter: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let setting = self.settings[Section(rawValue: indexPath.section)!]![indexPath.row]
        return setting.shouldHighlight
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        // Do nothing
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        // Do nothing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Animate the click
        let setting = self.settings[Section(rawValue: indexPath.section)!]![indexPath.row]
        if let segue = setting.segue {
            performSegue(withIdentifier: segue, sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Acknowledgements" {
            print("TODO: segue setup")
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

// MARK: - SettingsViewController Extension
extension SettingsViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        
        var environments = [UIFocusEnvironment]()
        if let parent = self.parent as? TabBarViewController {
            environments = environments + [parent.tabBar]
        }
        return environments
    }
}

// MARK: - Settings Enum

enum Settings {
    case login
    case theme
    case quality
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
        case .quality:
            return "Stream Quality"
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
        case .quality:
            return "Best"
        case .acknowledgements:
            return ""
        }
    }
}

extension Settings {
    var shouldHighlight: Bool {
        switch self {
        case .acknowledgements:
            return true
        default:
            return false
        }
    }
    var segue: String? {
        switch self {
        case .acknowledgements:
            return "Acknowledgements"
        default:
            return nil
        }
    }
}
