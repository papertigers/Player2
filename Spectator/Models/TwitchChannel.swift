//
//  TwitchChannel.swift
//  Spectator
//
//  Created by Michael Zeller on 7/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON


struct TwitchChannelCreds: TwitchToken, TwitchSig {
    let token: TwitchChannelToken
    let sig: TwitchChannelSig
    
    init(token: TwitchChannelToken, sig: TwitchChannelSig) {
        self.token = token
        self.sig = sig
    }
}

struct TwitchChannel: Channel {
    let id : Int
    var hashValue: Int {
        return id
    }
    let name : String
    let displayName : String
    let broadcasterLanguage : String?
    let language : String?
    let game : String?
    let logo : String?
    let status : String?
    let videoBanner : String?
    let followers : Int
    let views : Int
    
    
    /**
     Initializes a new TwitchChannel based on a JSON payload
     
     - parameter json: JSON payload from Twitch API
     
     - returns: TwitchChannel
     */
    init?(_ json: JSON) {
        guard let id = json["_id"].int,
            name = json["name"].string,
            displayName = json["display_name"].string,
            followers = json["followers"].int,
            views = json["views"].int else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.displayName = displayName
        self.followers = followers
        self.views = views
        
        self.logo = json["logo"].string
        self.videoBanner = json["video_banner"].string
        self.broadcasterLanguage = json["broadcaster_language"].string
        self.language = json["language"].string
        self.game = json["game"].string
        self.status = json["status"].string
    }
}

// MARK: Equatable
func ==(lhs: TwitchChannel, rhs: TwitchChannel) -> Bool {
    return lhs.hashValue == rhs.hashValue
}