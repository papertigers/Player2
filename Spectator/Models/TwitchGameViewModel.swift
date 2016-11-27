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
    
    init(game: TwitchGame) {
        self.game = game
        self.iconMultiplier = 380.0/272.0
        if let image = game.box(.Large) {
            self.icon = image
        } else {
            self.icon = "http://someimage"
        }
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
