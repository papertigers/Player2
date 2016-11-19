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
}

protocol TextPresentable {
    var text: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension TextPresentable {
    var textColor: UIColor { return .black }
    var font: UIFont { return UIFont(name: "HelveticaNeue-Light ", size: 12)!}
}