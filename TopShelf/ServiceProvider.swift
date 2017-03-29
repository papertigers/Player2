//
//  ServiceProvider.swift
//  TopShelf
//
//  Created by Michael Zeller on 1/30/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import Foundation
import TVServices
import Alamofire
import SwiftyJSON

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .sectioned
    }

    var topShelfItems: [TVContentItem] {
        guard let topGamesIdentifier = TVContentIdentifier(identifier: "Top Games", container: nil) else {
            return []
        }
        
        guard let topGamesSection = TVContentItem(contentIdentifier: topGamesIdentifier) else {
            return []
        }
        topGamesSection.title = "Top Games"
        
        // Start Semaphore
        let semaphore = DispatchSemaphore.init(value: 0)
        
        Alamofire.request(tapi.topGames(["limit": 25])).responseJSON { res in
            defer {
                semaphore.signal()
            }
            guard let value = res.result.value else {
                return
            }
            
            guard let games = JSON(value)["top"].array else {
                return
            }
            
            for game in games {
                let name = game["game"]["name"].stringValue
                let poster = game["game"]["box"]["large"].stringValue
                let gameIdentifier = TVContentIdentifier(identifier: name, container: nil)
                let gameItem = TVContentItem(contentIdentifier: gameIdentifier!)
                gameItem?.imageURL = URL(string: poster)!
                gameItem?.imageShape = .poster
                topGamesSection.topShelfItems?.append(gameItem!)
            }
        }
        
        // Wait for Semaphore
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return [topGamesSection]
    }

}

