//
//  ThirdPartyExtensions.swift
//  Spectator
//
//  Created by Michael Zeller on 7/5/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import SwiftyJSON
// MARK: Extensions

extension JSON {
    /**
     Dictonary mapping of String:String specific to Twitches API data
     */
    var dictOfString: [String:String]? {
        get {
            var mapped: [String:String] = [:]
            switch self.type {
            case .dictionary:
                var gen = self.makeIterator()
                while let x = gen.next() {
                    if let value = x.1.string {
                        mapped[x.0] = value
                    } else {
                        return nil
                    }
                }
                return mapped
            default:
                return nil
            }
        }
    }
}
