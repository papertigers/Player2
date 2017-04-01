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
    
    enum Section: Int {
        case general = 0, experience, about
    }
    
    let settings: [Section: [Settings]] = [
        .general: [Settings.login],
        .experience: [Settings.theme],
        .about: [Settings.acknowledgements]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        header?.textLabel?.textColor = .lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let settingsArray = self.settings[Section(rawValue: indexPath.section)!]!
        cell.textLabel?.text = settingsArray[indexPath.row].text
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let prevIndexPath = context.previouslyFocusedIndexPath {
            let prevCell = tableView.cellForRow(at: prevIndexPath)
            prevCell?.contentView.backgroundColor = .clear
            prevCell?.textLabel?.textColor = .white
        }
        
        if let nextIndexPath = context.nextFocusedIndexPath {
            let nextCell = tableView.cellForRow(at: nextIndexPath)
            nextCell?.contentView.backgroundColor = .white
            nextCell?.textLabel?.textColor = .black
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
