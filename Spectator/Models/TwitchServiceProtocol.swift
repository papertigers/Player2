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

protocol GameService {
    func getTopGames(limit: Int, offset: Int, completionHandler: (ServiceResult<[TwitchGame]> -> Void))
    func streamsForGame(limit: Int, offset: Int, game: TwitchGame, completionHandler: (ServiceResult<[TwitchStream]> -> Void))
}


protocol UndocumentedTwitchAPI {
    func getStreamsForChannel(channel: TwitchChannel, completionHandler: (ServiceResult<[TwitchStreamVideo]> -> Void))
}