//
//  ChannelViewController.swift
//  Player2
//
//  Created by Michael Zeller on 8/5/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher
import MarqueeLabel

class ChannelViewController: UIViewController {
    
    var channel: TwitchChannel!
    var stream: TwitchStream?

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var status: MarqueeLabel!
    @IBOutlet weak var game: UILabel!
    @IBOutlet weak var watchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupIfLive()
    }
    
    func setupIfLive() {
        let api = TwitchService()
        api.streamForChannel(id: channel.id) { [weak self] res in
            guard let stream = res.results else {
                return
            }
            self?.game.text = stream.game
            self?.stream = stream
            self?.watchButton.isHidden = false
        }
    }
    
    func setup() {
        self.view.backgroundColor = ColorScheme.backgroundColor
        
        self.username.text = channel.displayName
        self.username.textColor = ColorScheme.titleBarTextColor
        self.username.adjustsFontSizeToFitWidth = true
        
        self.game.textColor = ColorScheme.titleBarTextColor
        
        if let status = channel.status {
            self.status.text = status
            let scrollDuration: CGFloat = CGFloat(self.status.text?.characters.count ?? 0) * 0.09
            self.status.speed = .duration(scrollDuration)
            self.status.textColor = ColorScheme.titleBarTextColor
        }
        
        if let logo = channel.logo {
            let url = URL(string: logo)!
            icon.kf.setImage(with: url)
        }
        
        if let banner = channel.videoBanner {
            let url = URL(string: banner)!
            self.banner.kf.setImage(with: url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showstream" {
            guard let stream = self.stream else {
                return
            }
            let streamVC = segue.destination as! StreamController
            streamVC.stream = stream
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func watchClicked(_ sender: Any) {
        performSegue(withIdentifier: "showstream", sender: nil)
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
