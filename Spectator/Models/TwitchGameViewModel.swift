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
    
    init(game: TwitchGame) {
        self.game = game
        if let image = game.box(.Large) {
            self.icon = image
        } else {
            self.icon = "http://someimage"
        }
    }
}
