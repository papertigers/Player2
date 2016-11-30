//
//  ViewModelProtocols.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImagePresentable {
    var icon: String { get }
    var iconMultiplier: CGFloat { get }
    var placeholder: String { get }
    var cache: ImageCache { get }
}

protocol TextPresentable {
    var title: String { get }
    var subTitle: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension TextPresentable {
    var textColor: UIColor { return .black }
    var font: UIFont { return UIFont(name: "HelveticaNeue-Light ", size: 12)!}
}

struct ColorScheme {
    static let unselectedTextColor = UIColor(red:0.57, green:0.48, blue:0.69, alpha:1.0)
    static let backgroundColor = UIColor(red:0.20, green:0.08, blue:0.35, alpha:0.85)
}
