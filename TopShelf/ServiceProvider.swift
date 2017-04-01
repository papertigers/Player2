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
    
    // MARK: - TopShelf helper functions 
    func urlFor(game: TwitchGame) -> URL {
        var components = URLComponents()
        components.scheme = "player2"
        components.path = "/game"
        components.queryItems = [URLQueryItem(name: "name", value: game.name)]
        
        return components.url!
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
                guard let game = TwitchGame(game) else {
                    return
                }
                let gameIdentifier = TVContentIdentifier(identifier: game.name, container: nil)
                let gameItem = TVContentItem(contentIdentifier: gameIdentifier!)
                gameItem?.title = game.name
                gameItem?.imageURL = URL(string: game.box.large)
                gameItem?.imageShape = .poster
                let deepLink = self.urlFor(game: game)
                gameItem?.playURL = deepLink
                gameItem?.displayURL = deepLink
                topGamesSection.topShelfItems?.append(gameItem!)
            }
        }
        
        // Wait for Semaphore
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return [topGamesSection]
    }

}

