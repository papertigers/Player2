//
//  TwitchGameViewModel.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import Kingfisher

struct TwitchGameViewModel: ImagePresentable {
    let icon: String
    let game: TwitchGame
    let iconMultiplier: CGFloat
    let kf_processor: ImageProcessor?
    let placeholder = "GameDefault"
    let cache = P2ImageCache.GameCellCache
    
    init(game: TwitchGame) {
        self.game = game
        self.iconMultiplier = 380.0/272.0
        self.icon = game.box.large
        self.kf_processor = nil
    }
}

extension TwitchGameViewModel: TextPresentable {
    var title: String {
        return game.name
    }
    var subTitle: String {
        if (game.channels == 0) {
            return ""
        }
        return "\(game.channels) channels"
    }
}
