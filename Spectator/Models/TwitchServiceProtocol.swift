//
//  TwitchServiceProtocol.swift
//  Spectator
//
//  Created by Michael Zeller on 7/3/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

enum TwitchResult<T> {
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

protocol TwitchServiceProtocol {
    associatedtype T
    
    associatedtype Limit = Int
    associatedtype Offset = Int
    
    func getTopGames(limit: Limit, offset: Offset, completionHandler: TwitchResult<T>)
}