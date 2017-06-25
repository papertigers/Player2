//
//  TwitchChannelViewModel.swift
//  Player2
//
//  Created by Michael Zeller on 6/25/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import Kingfisher

struct TwitchChannelViewModel: ImagePresentable {
    let icon: String
    let channel: TwitchChannel
    let iconMultiplier: CGFloat
    let kf_processor: ImageProcessor?
    let placeholder = "StreamDefault"
    let cache = P2ImageCache.ChannelCellCache
    
    init(channel: TwitchChannel) {
        self.channel = channel
        self.icon = channel.videoBanner ?? defaultBanner
        self.iconMultiplier = 1080.0/1920.0
        self.kf_processor = ResizingImageProcessor(referenceSize: CGSize(width: 640.0, height: 360.0))

    }
}

extension TwitchChannelViewModel: TextPresentable {
    var title: String {
        return "\(channel.status ?? "")"
    }
    var subTitle: String {
        return channel.displayName
    }
}
