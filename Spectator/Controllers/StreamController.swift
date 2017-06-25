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
        
        //self.showsPlaybackControls = false  //Don't allow controls for livestreams
        self.requiresLinearPlayback = true //Twitch is a live stream so dont allow skipping
        
        twitch.getStreamsForChannel(stream.channel) { [weak self] res in
            guard let streams = res.results else {
                if let error = res.error {
                    Flurry.logError("StreamController", message: "Failed to get streams for \(String(describing: self?.stream))", error: error)
                }
                return
            }
            guard let strongSelf = self else {
                return
            }
        
            let userDefaults = UserDefaults.standard
            let value  = userDefaults.integer(forKey: "VideoQuality")
            let quality = StreamQuality(rawValue: value) ?? StreamQuality.source

            // Try to grab the users preferred stream quality.  If it doesnt exist grab one that does.
            let stream = streams.filter({$0.quality == quality.qualityValue}).first ?? streams.first
            Flurry.logEvent("Streaming", withParameters: ["Streamer": self?.stream.channel.name ?? "Unknown", "Game": strongSelf.stream.game ])
            //TODO: - Fix forced unwrap.
            let avItem = AVPlayerItem(asset: AVAsset(url: stream!.url))
            avItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
            avItem.externalMetadata = metadata(forTwitchStream: strongSelf.stream)
            self?.player = AVPlayer(playerItem: avItem)
            self?.player?.play()
        }
    }
}

// MARK: - Helper functions for AVPlayer Metadata

func metadataItem(identifier: String, value: (NSCopying & NSObjectProtocol)?) -> AVMetadataItem? {
    if let actualValue = value {
        let item = AVMutableMetadataItem()
        item.value = actualValue
        item.identifier = identifier
        item.extendedLanguageTag = "und"
        item.duration = kCMTimeIndefinite
        return item.copy() as? AVMetadataItem
    }
    return nil
}

func UIImageFromLogo(forChannel channel: TwitchChannel) -> UIImage? {
    guard let logo = channel.logo else { return nil }
    guard let url = URL(string: logo) else { return nil }
    guard let data = NSData(contentsOf: url) else { return nil }
    guard let image = UIImage(data: data as Data) else { return nil }
    return image
}

func metadata(forTwitchStream stream: TwitchStream) -> [AVMetadataItem] {
    var metadata: [AVMetadataItem] = []
    let t = "\(stream.channel.displayName) - \(stream.game)"
    if let title = metadataItem(identifier: AVMetadataCommonIdentifierTitle, value: t as (NSCopying & NSObjectProtocol)?) {
        metadata.append(title)
    }
    if let description = metadataItem(identifier: AVMetadataCommonIdentifierDescription, value: stream.channel.status as (NSCopying & NSObjectProtocol)?) {
        metadata.append(description)
    }
    if let image = UIImageFromLogo(forChannel: stream.channel) {
        if let artwork = UIImagePNGRepresentation(image) as (NSCopying & NSObjectProtocol)? {
            if let poster = metadataItem(identifier: AVMetadataCommonIdentifierArtwork, value: artwork) {
                metadata.append(poster)
            }
        }
    }
    return metadata
}
