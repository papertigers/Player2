//
//  TwitchUtils.swift
//  Player2
//
//  Created by Michael Zeller on 6/25/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import Foundation

let defaultBanner = "https://us-east.manta.joyent.com/papertigers/public/Player2/VideoBanner.png"

func getTwitchId(value: Any) -> Int? {
    switch value {
    case is Int:
        return value as? Int
    case is String:
        let s = value as! String
        return Int(s)
    default:
        return nil
    }
}
