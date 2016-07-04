//
//  TwitchService.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Willow


struct TwitchService: GameService {
    
    let log: Logger
    
    init() {
        let writers: [LogLevel: [Writer]] = [
        [.Error, .Info]: [ConsoleWriter()]
        ]
        log = Logger(configuration: LoggerConfiguration(writers: writers))
    }
    
    typealias TwitchResponse = Alamofire.Response
    enum TwitchError: ErrorType {
        case NoGames
    }
    
    private func checkResponse<T: AnyObject, U>(response: TwitchResponse<T, U>) -> ServiceResult<JSON> {
        guard let value = response.result.value else {
            return .Failure(response.result.error!)
        }
        return .Success(JSON(value))
    }
    
    
    typealias TopGamesCallback = (ServiceResult<[TwitchGame]> -> Void)
    func getTopGames(limit: Int = 10, offset: Int = 0, completionHandler: TopGamesCallback) {
        let parameters = [
            "limit": limit,
            "offset": offset
        ]
        Alamofire.request(tapi.TopGames(parameters)).responseJSON { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                self.log.debug{ "\(json)" }
                self.log.info{ "Got top games" }
                guard let games = json["top"].array else {
                    return completionHandler(.Failure(TwitchError.NoGames))
                }
                completionHandler(.Success(games.flatMap { TwitchGame($0) }))
            case .Failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.Failure(error))
            }
        }
    }
    
    struct Test: Stream {
        var a = 10
    }
    
    func streamsForGame(limit: Int = 25 , offset: Int = 0, game: TwitchGame, completionHandler: (ServiceResult<Test> -> Void)) {
        let parameteres = [
            "limit": limit,
            "offset": offset,
            "game": game.name
        ]
        Alamofire.request(tapi.Streams(parameteres as! [String : AnyObject])).responseJSON { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                print(json)
            case .Failure(let error):
                print(error)
            }
        }
    }
}