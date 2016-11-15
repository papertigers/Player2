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
    case success(T)
    case failure(Error)
    
    var isSuccess: Bool  {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var results: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success(_):
            return nil
        case .failure(let value):
            return value
        }
    }
}

protocol GameService {
    func getTopGames(_ limit: Int, offset: Int, completionHandler: @ escaping((ServiceResult<[TwitchGame]>) -> Void))
    func streamsForGame(_ limit: Int, offset: Int, game: TwitchGame, completionHandler: @escaping ((ServiceResult<[TwitchStream]>) -> Void))
}


protocol UndocumentedTwitchAPI {
    func getStreamsForChannel(_ channel: TwitchChannel, completionHandler: @escaping ((ServiceResult<[TwitchStreamVideo]>) -> Void))
}
