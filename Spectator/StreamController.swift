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
        
        twitch.getStreamsForChannel(stream.channel) { [weak self] res in
            guard let streams = res.results else {
                return print("Error getting streams: \(res.error)")
            }
            
            let chunked = streams.filter({$0.quality == "chunked"}).first
            print(chunked)
            self?.player = AVPlayer(url: chunked!.url)
            self?.player?.play()
        }
    }
}
