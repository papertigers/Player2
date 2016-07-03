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

enum tapi: URLRequestConvertible {
    static let baseURLString = "https://api.twitch.tv/kraken"
    static var OAuthToken: String?
    
    // Games
    case TopGames([String:Int])
    
    var method: Alamofire.Method {
        switch self {
        case .TopGames:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .TopGames:
            return "/games/top"
        }
    }
    
    var apiVersion: TwitchAPIVersion {
        switch self {
        default:
            return .v3
        }
    }
    
    // MARK: URLRequsetConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: tapi.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        
        if let token = tapi.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        mutableURLRequest.setValue(apiVersion.rawValue, forHTTPHeaderField: "Accept")
        
        switch self {
        case .TopGames(let parameters):
            return Alamofire.ParameterEncoding.URLEncodedInURL.encode(mutableURLRequest, parameters: parameters).0
        }
    }
}
