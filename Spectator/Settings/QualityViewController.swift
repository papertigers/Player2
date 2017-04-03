//
//  QualityViewController.swift
//  Player2
//
//  Created by Michael Zeller on 4/3/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit

class QualityViewController: UIViewController {
    weak var delegate: UpdateSettingsDelegate?
    var focusItem = 0
    
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var mobileButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    
    @IBAction func handleButton(_ sender: UIButton) {
        //Handle Quality change
        guard let quality = StreamQuality.init(rawValue: sender.tag) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        changeQuality(to: quality)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - Video Quality Change
    func changeQuality(to quality: StreamQuality) {
        let userDefaults = UserDefaults.standard
        userDefaults.set( quality.rawValue, forKey: "VideoQuality")
        self.delegate?.updateSettings()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension QualityViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var environments = [UIFocusEnvironment]()
        if let button = self.view.viewWithTag(focusItem) as? UIButton
        {
            environments = environments + [button]
        }
        return environments
    }
}

enum StreamQuality: Int {
    case source = 0, high, medium, low, mobile, audio
    
    var qualityValue: String {
        switch self {
        case .source:
            return "chunked"
        case .high:
            return "high"
        case .medium:
            return "medium"
        case .low:
            return "low"
        case .mobile:
            return "mobile"
        case .audio:
            return "audio_only"
        }
    }
    
    var qualityString: String {
        switch self {
        case .source:
            return "Source"
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        case .mobile:
            return "Mobile"
        case .audio:
            return "Audio"
        }
    }
}
