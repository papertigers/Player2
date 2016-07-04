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

protocol Testing {
    var a: Int { get }
}

protocol GameService {
    associatedtype T: Game
    func getTopGames(limit: Int, offset: Int, completionHandler: (ServiceResult<[T]> -> Void))
}