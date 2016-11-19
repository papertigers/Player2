//
//  File.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation

protocol TwitchAdapter {
    associatedtype Item: Hashable
    var offset: Int { get }
    var limit: Int { get }
    var items: [Item] { get }
    func load(fromOffset offset: Int, limit: Int)
}
