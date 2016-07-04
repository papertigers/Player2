//
//  TwitchGame.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TwitchGame: Game {
    let name: String
    let box: [String:String]
    let logo: [String:String]
    let id: Int
    let viewers: Int
    let channels: Int
    
    var hashValue: Int {
        return id
    }
    
    init?(_ json: JSON) {
        guard let id = json["game"]["_id"].int,
            name = json["game"]["name"].string,
            box = json["game"]["box"].dictOfString,
            logo = json["game"]["logo"].dictOfString,
            viewers = json["viewers"].int,
            channels = json["channels"].int else {
            return nil
        }
        self.name = name
        self.box = box
        self.logo = logo
        self.id = id
        self.viewers = viewers
        self.channels = channels
    }
    
    func mapValues(dict: [String:JSON]) -> [String:String] {
        var gen = dict.generate()
        var mapped: [String:String] = [:]
        while let x =  gen.next() {
            mapped[x.0] = x.1.string ?? ""
        }
        return mapped
    }
}

func ==(lhs: TwitchGame, rhs: TwitchGame) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


private extension JSON {
    var dictOfString: [String:String]? {
        get {
            var mapped: [String:String] = [:]
            switch self.type {
            case .Dictionary:
                var gen = self.generate()
                while let x = gen.next() {
                    mapped[x.0] = x.1.string ?? ""
                }
                return mapped
            default:
                return nil
            }
        }
    }
}