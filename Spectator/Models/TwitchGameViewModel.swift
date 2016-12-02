//
//  TwitchGameViewModel.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

struct TwitchGameViewModel: ImagePresentable {
    let icon: String
    let game: TwitchGame
    let iconMultiplier: CGFloat
    let placeholder = "GameDefault"
    let cache = P2ImageCache.GameCellCache
    
    init(game: TwitchGame) {
        self.game = game
        self.iconMultiplier = 380.0/272.0
        self.icon = game.box.large
    }
}

extension TwitchGameViewModel: TextPresentable {
    var title: String {
        return game.name
    }
    var subTitle: String {
        return "\(game.channels) channels"
    }
}
