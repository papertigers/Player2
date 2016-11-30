//
//  StreamController.swift
//  Player2
//
//  Created by Michael Zeller on 11/14/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import AVKit


class StreamController: AVPlayerViewController {
    var stream: TwitchStream!
    let twitch = TwitchService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showsPlaybackControls = false  //Don't allow controls for livestreams
        
        twitch.getStreamsForChannel(stream.channel) { [weak self] res in
            guard let streams = res.results else {
                print("Error getting streams: \(res.error)")
                // TODO: push the viewcontroller back or display error.
                return
            }
            
            let chunked = streams.filter({$0.quality == "chunked"}).first
            print(chunked)
            self?.player = AVPlayer(url: chunked!.url)
            self?.player?.play()
        }
    }
}
