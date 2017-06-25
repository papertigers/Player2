//
//  TwitchRouter.swift
//  Spectator
//
//  Created by Michael Zeller on 7/2/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import Alamofire

enum TwitchSearch: String {
    case games = "games"
    case streams = "streams"
}
enum TwitchAPIVersion: String {
    case v2 = "application/vnd.twitchtv.v2+json"
    case v3 = "application/vnd.twitchtv.v3+json"
    case v5 = "application/vnd.twitchtv.v5+json"
}

let CLIENT_ID  = "4t85h8m64oxmccc25iqpbg9amuy4x57"

enum tapi: URLRequestConvertible {
    static let baseURLString = "https://api.twitch.tv/kraken"
    static let tokenURLString = "https://api.twitch.tv/api"
    static let videoStreamsURLString = "http://usher.twitch.tv/api"
    static var OAuthToken: String?
    
    // Games
    case topGames([String:Int])
    // Streams
    case streams([String:AnyObject])
    case featuredStreams([String:Int])
    // Search
    case search(TwitchSearch, [String:AnyObject])
    // Undocumented API for VideoStreams
    case channelToken(TwitchChannel)
    case videoStreams(TwitchChannel, [String:AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .topGames:
            return .get
        case .streams:
            return .get
        case .featuredStreams:
            return .get
        case .search:
            return .get
        case .channelToken:
            return .get
        case .videoStreams:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .topGames:
            return "/games/top"
        case .streams:
            return "/streams"
        case .featuredStreams:
            return "/streams/featured"
        case .search(let type, _):
            return "/search/\(type.rawValue)"
        case .channelToken(let channel):
            return "/channels/\(channel.name)/access_token"
        case .videoStreams(let channel, _):
            return "/channel/hls/\(channel.name).m3u8"
        }
    }
    
    var apiVersion: TwitchAPIVersion {
        switch self {
        default:
            return .v5
        }
    }
    
    // We have to change the base URL unfortunately 
    // because we have to use an undocumented API occassionally
    var apiURL: String {
        switch self {
        case .channelToken:
            return tapi.tokenURLString
        case .videoStreams:
            return tapi.videoStreamsURLString
        default:
            return tapi.baseURLString
        }
    }
    
    // MARK: URLRequsetConvertible
    
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: apiURL)!
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.httpMethod = method.rawValue
        
        
        
        if let token = tapi.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        mutableURLRequest.setValue(CLIENT_ID, forHTTPHeaderField: "Client-ID")
        mutableURLRequest.setValue(apiVersion.rawValue, forHTTPHeaderField: "Accept")
        mutableURLRequest.timeoutInterval = 5.0
        
        switch self {
        case .topGames(let parameters):
            mutableURLRequest = try URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .streams(let parameters):
            mutableURLRequest = try URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .featuredStreams(let parameters):
            mutableURLRequest = try URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .search( _, let parameters):
            mutableURLRequest = try URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .videoStreams(_, let parameters):
            //We have to nil out the accept header or twitch gets cranky
            mutableURLRequest.setValue("", forHTTPHeaderField: "Accept")
            mutableURLRequest = try URLEncoding.default.encode(mutableURLRequest, with: parameters)
        default:
            break
        }
        
        return mutableURLRequest
    }
}
