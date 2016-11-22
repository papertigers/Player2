//
//  TwitchChannelViewModel.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

struct TwitchStreamViewModel: ImagePresentable {
    let icon: String
    let stream: TwitchStream
    let iconMultiplier: CGFloat
    let placeholder = "StreamDefault"
    
    init(stream: TwitchStream) {
        self.stream = stream
        self.icon = stream.preview["large"]!
        self.iconMultiplier = 360.0/640.0
    }
}

extension TwitchStreamViewModel: TextPresentable {
    var title: String {
        return stream.channel.status ?? stream.game
    }
    var subTitle: String {
        return "\(stream.viewers) viewing \(stream.channel.displayName)"
    }
}
