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
    static let unselectedTextColor = UIColor(red:0.66, green:0.56, blue:0.84, alpha:1.0)
    //static let backgroundColor = UIColor.black //OLED
    static let backgroundColor = UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
    // Titlebar
    static let titleBarBackgroundColor =  UIColor(red:0.39, green:0.25, blue:0.64, alpha:1.0)
    static let titleBarTextColor: UIColor = .white
}
