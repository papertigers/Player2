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
    
    init(stream: TwitchStream) {
        self.stream = stream
        self.icon = stream.preview["large"]!
    }
}

extension TwitchStreamViewModel: TextPresentable {
    var title: String {
        return stream.channel.displayName
    }
}
