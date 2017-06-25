//
//  TwitchUtils.swift
//  Player2
//
//  Created by Michael Zeller on 6/25/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import Foundation

func getTwitchId(value: Any) -> Int? {
    switch value {
    case is Int:
        return value as? Int
    case is String:
        let s = value as! String
        if let id = Int(s) {
            return id
        }
        return nil
    default:
        return nil
    }
}
