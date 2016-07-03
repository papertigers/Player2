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


struct TwitchService {
    
    let log: Logger
    
    init() {
        let writers: [LogLevel: [Writer]] = [
        [.Error, .Info]: [ConsoleWriter()]
        ]
        log = Logger(configuration: LoggerConfiguration(writers: writers))
    }
    
    typealias TwitchResponse = Alamofire.Response
    
    private func checkResponse<T: AnyObject, U>(response: TwitchResponse<T, U>) -> TwitchResult<JSON> {
        var result: TwitchResult<JSON>
        if let value = response.result.value {
            let json = JSON(value)
            result = TwitchResult.Success(json)
        } else {
            result = TwitchResult.Failure(response.result.error!)
        }
        return result
    }
    
    typealias Limit = Int
    typealias Offset = Int
    
    typealias TopGamesCallback = (TwitchResult<JSON> -> Void)
    func getTopGames(limit: Limit = 10, offset: Offset = 0, completionHandler: TopGamesCallback) {
        let parameters = [
            "limit": limit,
            "offset": offset
        ]
        Alamofire.request(tapi.TopGames(parameters)).responseJSON { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                self.log.debug{ "\(json)" }
                self.log.info{ "Got top games" }
                completionHandler(.Success(json))
            case .Failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.Failure(error))
            }
        }
    }
}