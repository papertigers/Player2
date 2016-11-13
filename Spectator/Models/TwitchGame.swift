//
//  TwitchGame.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON
import IGListKit

/// A Twitch Game
struct TwitchGame: Hashable {
    let name: String
    let box: [String:String]
    let logo: [String:String]
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
            let box = json["game"]["box"].dictOfString,
            let logo = json["game"]["logo"].dictOfString,
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
    
    /**
    Get a box(poster) by size
    - parameter forSize: Size of box to be returned
    - returns: box URL
    */
    func box(_ forSize: Size) -> String? {
        return box[forSize.rawValue]
    }
    
    /**
    Get a logo by size
    - parameter forSize: Size of logo to be returned
    - returns: logo URL
    */
    func logo(_ forSize: Size) -> String? {
        return logo[forSize.rawValue]
    }
}

// MARK: Equatable
func ==(lhs: TwitchGame, rhs: TwitchGame) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
