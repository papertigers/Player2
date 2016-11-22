//
//  ViewModelProtocols.swift
//  Player2
//
//  Created by Michael Zeller on 11/19/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

protocol ImagePresentable {
    var icon: String { get }
    var iconMultiplier: CGFloat { get }
    var placeholder: String { get }
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
