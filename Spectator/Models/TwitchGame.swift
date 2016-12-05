//
//  TwitchGame.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON

/// A Twitch Game
struct TwitchGame: Hashable, TwitchSearchItem {
    let name: String
    let box: TwitchPreview
    let logo: TwitchPreview
    let id: Int
    let viewers: Int
    let channels: Int
    
    var hashValue: Int {
        return id
    }
    
    enum Size: String {
        case Large = "large"
        case Medium = "medium"
        case Small = "small"
        case Template = "template"
    }
    
    /**
     Initializes a new TwitchGame based on a JSON payload
     
     - parameter json: JSON payload from Twitch API
     
     - returns: TwitchGame
    */
    init?(_ json: JSON) {
        guard let id = json["game"]["_id"].int,
            let name = json["game"]["name"].string,
            let box = TwitchPreview(json["game"]["box"]),
            let logo = TwitchPreview(json["game"]["logo"]),
            let viewers = json["viewers"].int,
            let channels = json["channels"].int else {
            return nil
        }
        self.name = name
        self.box = box
        self.logo = logo
        self.id = id
        self.viewers = viewers
        self.channels = channels
    }
    
    init?(searchResults json: JSON) {
        guard let id = json["_id"].int,
            let name = json["name"].string,
            let box = TwitchPreview(json["box"]),
            let logo = TwitchPreview(json["logo"]) else {
                return nil
        }
        self.name = name
        self.box = box
        self.logo = logo
        self.id = id
        self.viewers = 0
        self.channels = 0
    }
}

// MARK: Equatable
func ==(lhs: TwitchGame, rhs: TwitchGame) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
