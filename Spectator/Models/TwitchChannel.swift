//
//  TwitchChannel.swift
//  Spectator
//
//  Created by Michael Zeller on 7/4/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON


struct TwitchChannelCreds {
    typealias TwitchChannelToken = String
    typealias TwitchChannelSig = String
    let token: TwitchChannelToken
    let sig: TwitchChannelSig
    
    init(token: TwitchChannelToken, sig: TwitchChannelSig) {
        self.token = token
        self.sig = sig
    }
}

struct TwitchChannel: Hashable {
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
            let name = json["name"].string,
            let displayName = json["display_name"].string,
            let followers = json["followers"].int,
            let views = json["views"].int else {
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