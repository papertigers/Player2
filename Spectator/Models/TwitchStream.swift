//
//  TwitchStream.swift
//  Spectator
//
//  Created by Michael Zeller on 7/5/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TwitchStream: Hashable {
    let id: Int
    var hashValue: Int {
        return id
    }
    let game: String
    let viewers: Int
    let videoHeight: Int
    let isPlaylist: Bool
    let preview: [String:String]
    let channel: TwitchChannel
    
    /**
     Initializes a new TwitchStream based on a JSON payload
     
     - parameter json: JSON payload from Twitch API
     
     - returns: TwitchStream
     */
    init?(_ json: JSON) {
        guard let id = json["_id"].int,
            let game = json["game"].string,
            let videoHeight = json["video_height"].int,
            let isPlaylist = json["is_playlist"].bool,
            let viewers = json["viewers"].int,
            let preview = json["preview"].dictOfString,
            let channel = TwitchChannel(json["channel"])
            else {
                return nil
        }
        
        self.id = id
        self.game = game
        self.viewers = viewers
        self.videoHeight = videoHeight
        self.isPlaylist = isPlaylist
        self.preview = preview
        self.channel = channel
    }
}

// MARK: Equatable
func ==(lhs: TwitchStream, rhs: TwitchStream) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
