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
    static let backgroundQueue = dispatch_queue_create("com.lightsandshapes.response-queue", DISPATCH_QUEUE_CONCURRENT)

    /**
     Initializes a new TwitchService used to interact with the Twitch API
     - returns: TwitchService
     */
    init() {
        let writers: [LogLevel: [Writer]] = [
        [.Error, .Info]: [ConsoleWriter()]
        ]
        log = Logger(configuration: LoggerConfiguration(writers: writers))
    }
    
    typealias TwitchResponse = Alamofire.Response
    enum TwitchError: ErrorType {
        case NoGames
        case NoStreams
        case FailedToRetrieveTokenOrSig
        case FailedToParseM3U
    }
    
    /**
     Checks a Twitch API response was successful and if so, returns the JSON payload
     
     - parameter response: Twitch API response (from Alamofire)
     
     - returns: JSON payload if successful
     */
    private func checkResponse<T: AnyObject, U>(response: TwitchResponse<T, U>) -> ServiceResult<JSON> {
        guard let value = response.result.value else {
            return .Failure(response.result.error!)
        }
        return .Success(JSON(value))
    }
    
    
    typealias TopGamesCallback = (ServiceResult<[TwitchGame]> -> Void)
    /**
     Gets the most top streamed games from Twitch
     
     - parameter limit: Number of results to return
     - parameter offset: Offset to start at
     - parameter completionHandler: Callback called with possible array of top games
     
     */
    func getTopGames(limit: Int = 10, offset: Int = 0, completionHandler: TopGamesCallback) {
        let parameters = [
            "limit": limit,
            "offset": offset
        ]
        Alamofire.request(tapi.TopGames(parameters)).validate(statusCode: 200..<300).responseJSON { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                self.log.debug{ "\(json)" }
                self.log.info{ "Got top games" }
                guard let games = json["top"].array else {
                    return completionHandler(.Failure(TwitchError.NoGames))
                }
                dispatch_async(TwitchService.backgroundQueue) {
                    let g = games.flatMap { TwitchGame($0) }
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(.Success(g))
                    }
                }
            case .Failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.Failure(error))
            }
        }
    }
    
    /**
     Get the top streams for a given TwitchGame
     
     - parameter limit: Number of results to return
     - parameter offset: Offset to start at
     - parameter game: TwitchGame to get streams for
     - parameter completionHandler: Callback called with possible array of top streams

    */
    func streamsForGame(limit: Int = 25 , offset: Int = 0, game: TwitchGame, completionHandler: (ServiceResult<[TwitchStream]> -> Void)) {
        let parameteres = [
            "limit": limit,
            "offset": offset,
            "live": true,
            "game": game.name
        ]
        Alamofire.request(tapi.Streams(parameteres as! [String : AnyObject])).validate(statusCode: 200..<300).responseJSON { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                self.log.debug{ "\(json)" }
                guard let streams = json["streams"].array else {
                    return completionHandler(.Failure(TwitchError.NoStreams))
                }
                self.log.info{ "Got streams for game: \(game.name)" }
                dispatch_async(TwitchService.backgroundQueue) {
                    let s = streams.flatMap { TwitchStream($0) }
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(.Success(s))
                    }
                }
            case .Failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.Failure(error))
            }
        }
    }
}
    
    // MARK: Undocumented Twitch API
    
extension TwitchService: UndocumentedTwitchAPI {
    /**
     Get a channel token and sig for a given TwitchChannel
     
     - parameter channel: TwitchChannel
     - parameter completionHandler: Callback called with possible TwitchChannelCreds
     
     */
    private func getChannelTokenAndSig(channel: TwitchChannel, completionHandler: (ServiceResult<TwitchChannelCreds> -> Void)) {
        Alamofire.request(tapi.ChannelToken(channel)).validate(statusCode: 200..<300).responseJSON(queue: TwitchService.backgroundQueue) { response in
            switch self.checkResponse(response) {
            case .Success(let json):
                self.log.debug{ "\(json)" }
                guard let token = json["token"].string,
                sig = json["sig"].string else {
                    return completionHandler(.Failure(TwitchError.FailedToRetrieveTokenOrSig))
                }
                self.log.info{ "Got token and sig for channel: \(channel.name)" }
                completionHandler(.Success(TwitchChannelCreds(token: token, sig: sig)))
            case .Failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.Failure(error))
            }
        }
    }
    
    /**
     Get a channels live streams for a given TwitchChannel
     
     - parameter channel: TwitchChannel
     - parameter completionHandler: Callback called with possible array of TwitchStreamVideo
     
     */
    func getStreamsForChannel(channel: TwitchChannel, completionHandler: (ServiceResult<[TwitchStreamVideo]> -> Void)) {
        getChannelTokenAndSig(channel) { res in
            switch res {
            case .Success(let tokenAndSig):
                let parameters = [
                    "player"            : "twitchweb",
                    "allow_audio_only"  : true,
                    "allow_source"      : true,
                    "mobile_restricted" : false,
                    "type"              : "any",
                    "p"                 : Int(arc4random_uniform(99999)),
                    "token"             : tokenAndSig.token,
                    "sig"               : tokenAndSig.sig
                ]
                Alamofire.request(tapi.VideoStreams(channel, parameters as! [String : AnyObject])).validate(statusCode: 200..<300).responseString(queue: TwitchService.backgroundQueue) { res2 in
                    switch res2.result {
                    case .Success(let rawM3U):
                        guard let streams = M3UParser.parseToDict(rawM3U) else {
                            dispatch_async(dispatch_get_main_queue()) {
                                completionHandler(.Failure(TwitchError.FailedToParseM3U))
                            }
                            return
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(.Success(streams))
                        }
                    case .Failure(let error):
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(.Failure(error))
                        }
                    }
                }
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
}