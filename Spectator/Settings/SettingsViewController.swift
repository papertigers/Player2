//
//  SettingsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 4/1/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit
import Reusable

protocol UpdateSettingsDelegate: class {
    func updateSettings()
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateSettingsDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var focuseTableView = false
    
    enum Section: Int {
        case general = 0, experience, about
    }
    
    let settings: [Section: [Settings]] = [
        .general: [Settings.login],
        .experience: [Settings.quality],
        .about: [Settings.acknowledgements, Settings.version]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: SettingsCell.self)
        tableView.remembersLastFocusedIndexPath = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.tableView.setNeedsDisplay()
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
        // Uncoment the following to only allow selction of settings based on shouldHighlight property
        let setting = self.settings[Section(rawValue: indexPath.section)!]![indexPath.row]
        return setting.shouldHighlight
        //return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        // Do nothing
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        // Do nothing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = self.settings[Section(rawValue: indexPath.section)!]![indexPath.row]
        let cell = self.tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }, completion: { (val) in
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            }, completion: { (_) in
                if let segue = setting.segue {
                    self.performSegue(withIdentifier: segue, sender: indexPath)
                }
                
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Settings.quality.segue {
            let qualityVC = segue.destination as! QualityViewController
            qualityVC.delegate = self
            let userDefaults = UserDefaults.standard
            let value  = userDefaults.integer(forKey: "VideoQuality")
            let quality = StreamQuality(rawValue: value) ?? StreamQuality.source
            qualityVC.focusItem = quality.rawValue
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
    
    // MARK: - UpdateSettingsDelegate
    func updateSettings() {
        self.focuseTableView = true
        self.tableView.reloadData()
    }

}

// MARK: - SettingsViewController Extension
extension SettingsViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        
        var environments = [UIFocusEnvironment]()
        if focuseTableView {
            environments = environments + [self.tableView]
            self.focuseTableView = false
        }
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
    case version
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
        case .version:
            return "Version"
        }
    }
    var subText: String {
        switch self {
        case .login:
            return "(Coming Soon)"
        case .theme:
            return "Default"
        case .quality:
            let userDefaults = UserDefaults.standard
            let value  = userDefaults.integer(forKey: "VideoQuality")
            let quality = StreamQuality(rawValue: value) ?? StreamQuality.source
            return quality.qualityString
        case .acknowledgements:
            return ""
        case .version:
            let version = Bundle.main.releaseVersionNumber ?? ""
            let build = Bundle.main.buildVersionNumber ?? ""
            return "\(version) (\(build))"
        }
    }
}

extension Settings {
    var shouldHighlight: Bool {
        switch self {
        case .acknowledgements:
            return true
        case .quality:
            return true
        default:
            return false
        }
    }
    var segue: String? {
        switch self {
        case .acknowledgements:
            return "Acknowledgements"
        case .quality:
            return "Quality"
        default:
            return nil
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
