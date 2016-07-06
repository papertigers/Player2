//
//  TwitchServiceProtocol.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ServiceResult<T> {
    case Success(T)
    case Failure(ErrorType)
    
    var isSuccess: Bool  {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var results: T? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
}

protocol Game: Hashable {
    var name: String { get }
    var id: Int  { get }
    var hashValue: Int { get }
    func ==(lhs: Self, rhs:Self) -> Bool
}

protocol Channel: Hashable {
    var name: String { get }
    var id: Int { get }
    var displayName: String { get }
    func ==(lhs: Self, rhs:Self) -> Bool
}

protocol Stream: Hashable {
    associatedtype C: Channel
    var id: Int { get }
    var game: String { get }
    var viewers: Int { get }
    var videoHeight: Int { get }
    var isPlaylist: Bool { get }
    var preview: [String:String] { get }
    var channel: C { get }
    func ==(lhs: Self, rhs:Self) -> Bool
}

protocol GameService {
    associatedtype G: Game
    associatedtype S: Stream
    func getTopGames(limit: Int, offset: Int, completionHandler: (ServiceResult<[G]> -> Void))
    func streamsForGame(limit: Int, offset: Int, game: G, completionHandler: (ServiceResult<[S]> -> Void))
}

typealias TwitchChannelToken = String
typealias TwitchChannelSig = String
protocol TwitchToken {
    var token: TwitchChannelToken { get }
}
protocol TwitchSig {
    var sig: TwitchChannelSig { get }
}

protocol UndocumentedTwitchAPI {
    func getStreamsForChannel(channel: TwitchChannel, completionHandler: (ServiceResult<[TwitchStreamVideo]> -> Void))
}