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
    static let backgroundQueue = DispatchQueue(label: "com.lightsandshapes.response-queue", attributes: DispatchQueue.Attributes.concurrent)

    /**
     Initializes a new TwitchService used to interact with the Twitch API
     - returns: TwitchService
     */
    init() {
        let writers: [LogLevel: [LogMessageWriter]] = [
        [.error, .info]: [ConsoleWriter()]
        ]
        log = Logger(configuration: LoggerConfiguration(writers: writers))
    }
    
    typealias TwitchResponse = Alamofire.DataResponse
    enum TwitchError: Error {
        case noGames
        case noStreams
        case failedToRetrieveTokenOrSig
        case failedToParseM3U
    }
    
    /**
     Checks a Twitch API response was successful and if so, returns the JSON payload
     
     - parameter response: Twitch API response (from Alamofire)
     
     - returns: JSON payload if successful
     */
    fileprivate func checkResponse<T: Any>(_ response: TwitchResponse<T>) -> ServiceResult<JSON> {
        guard let value = response.result.value else {
            return .failure(response.result.error!)
        }
        return .success(JSON(value))
    }
    
    
    typealias TopGamesCallback = ((ServiceResult<[TwitchGame]>) -> Void)
    /**
     Gets the most top streamed games from Twitch
     
     - parameter limit: Number of results to return
     - parameter offset: Offset to start at
     - parameter completionHandler: Callback called with possible array of top games
     
     */
    func getTopGames(_ limit: Int = 10, offset: Int = 0, completionHandler: @escaping TopGamesCallback) {
        let parameters = [
            "limit": limit,
            "offset": offset
        ]
        Alamofire.request(tapi.topGames(parameters)).validate(statusCode: 200..<300).responseJSON { response in
            switch self.checkResponse(response) {
            case .success(let json):
                self.log.debug{ "\(json)" }
                self.log.info{ "Got top games" }
                guard let games = json["top"].array else {
                    return completionHandler(.failure(TwitchError.noGames))
                }
                TwitchService.backgroundQueue.async {
                    let g = games.flatMap { TwitchGame($0) }
                    DispatchQueue.main.async() {
                        completionHandler(.success(g))
                    }
                }
            case .failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.failure(error))
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
    func streamsForGame(_ limit: Int = 25 , offset: Int = 0, game: TwitchGame, completionHandler: @escaping ((ServiceResult<[TwitchStream]>) -> Void)) {
        let parameteres = [
            "limit": limit,
            "offset": offset,
            "live": true,
            "game": game.name
        ] as [String : Any]
        Alamofire.request(tapi.streams(parameteres as [String : AnyObject])).validate(statusCode: 200..<300).responseJSON { response in
            switch self.checkResponse(response) {
            case .success(let json):
                self.log.debug{ "\(json)" }
                guard let streams = json["streams"].array else {
                    return completionHandler(.failure(TwitchError.noStreams))
                }
                self.log.info{ "Got streams for game: \(game.name)" }
                TwitchService.backgroundQueue.async {
                    let s = streams.flatMap { TwitchStream($0) }
                    DispatchQueue.main.async {
                        completionHandler(.success(s))
                    }
                }
            case .failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.failure(error))
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
    fileprivate func getChannelTokenAndSig(_ channel: TwitchChannel, completionHandler: @escaping ((ServiceResult<TwitchChannelCreds>) -> Void)) {
        Alamofire.request(tapi.channelToken(channel)).validate(statusCode: 200..<300).responseJSON(queue: TwitchService.backgroundQueue) { response in
            switch self.checkResponse(response) {
            case .success(let json):
                self.log.debug{ "\(json)" }
                guard let token = json["token"].string,
                let sig = json["sig"].string else {
                    return completionHandler(.failure(TwitchError.failedToRetrieveTokenOrSig))
                }
                self.log.info{ "Got token and sig for channel: \(channel.name)" }
                completionHandler(.success(TwitchChannelCreds(token: token, sig: sig)))
            case .failure(let error):
                self.log.error { "\(error)" }
                completionHandler(.failure(error))
            }
        }
    }
    
    /**
     Get a channels live streams for a given TwitchChannel
     
     - parameter channel: TwitchChannel
     - parameter completionHandler: Callback called with possible array of TwitchStreamVideo
     
     */
    func getStreamsForChannel(_ channel: TwitchChannel, completionHandler: @escaping ((ServiceResult<[TwitchStreamVideo]>) -> Void)) {
        getChannelTokenAndSig(channel) { res in
            switch res {
            case .success(let tokenAndSig):
                let parameters = [
                    "player"            : "twitchweb",
                    "allow_audio_only"  : true,
                    "allow_source"      : true,
                    "mobile_restricted" : false,
                    "type"              : "any",
                    "p"                 : Int(arc4random_uniform(99999)),
                    "token"             : tokenAndSig.token,
                    "sig"               : tokenAndSig.sig
                ] as [String : Any]
                Alamofire.request(tapi.videoStreams(channel, parameters as [String : AnyObject])).validate(statusCode: 200..<300).responseString(queue: TwitchService.backgroundQueue) { res2 in
                    switch res2.result {
                    case .success(let rawM3U):
                        guard let streams = M3UParser.parseToDict(rawM3U) else {
                            DispatchQueue.main.async {
                                completionHandler(.failure(TwitchError.failedToParseM3U))
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            completionHandler(.success(streams))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
