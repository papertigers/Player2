//
//  TwitchRouter.swift
//  Spectator
//
//  Created by Michael Zeller on 7/2/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Foundation
import Alamofire

enum TwitchAPIVersion: String {
    case v2 = "application/vnd.twitchtv.v2+json"
    case v3 = "application/vnd.twitchtv.v3+json"
}

let CLIENT_ID  = "Spectator"

enum tapi: URLRequestConvertible {
    static let baseURLString = "https://api.twitch.tv/kraken"
    static let tokenURLString = "https://api.twitch.tv/api"
    static var OAuthToken: String?
    
    // Games
    case TopGames([String:Int])
    // Streams
    case Streams([String:AnyObject])
    // Undocumented API for VideoStreams
    case ChannelToken(TwitchChannel)
    
    var method: Alamofire.Method {
        switch self {
        case .TopGames:
            return .GET
        case .Streams:
            return .GET
        case .ChannelToken:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .TopGames:
            return "/games/top"
        case .Streams:
            return "/streams"
        case .ChannelToken(let channel):
            return "/channels/\(channel.name)/access_token"
        }
    }
    
    var apiVersion: TwitchAPIVersion {
        switch self {
        default:
            return .v3
        }
    }
    
    // We have to change the base URL unfortunately 
    // because we have to use an undocumented API occassionally
    var apiURL: String {
        switch self {
        case .ChannelToken:
            return tapi.tokenURLString
        default:
            return tapi.baseURLString
        }
    }
    
    // MARK: URLRequsetConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: apiURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        
        if let token = tapi.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        mutableURLRequest.setValue(CLIENT_ID, forHTTPHeaderField: "Client-ID")
        mutableURLRequest.setValue(apiVersion.rawValue, forHTTPHeaderField: "Accept")
        
        switch self {
        case .TopGames(let parameters):
            return Alamofire.ParameterEncoding.URLEncodedInURL.encode(mutableURLRequest, parameters: parameters).0
        case .Streams(let parameters):
            return Alamofire.ParameterEncoding.URLEncodedInURL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
