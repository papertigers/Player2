//
//  TwitchPreview.swift
//  Player2
//
//  Created by Michael Zeller on 11/29/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import SwiftyJSON

struct TwitchPreview {
    let large: String
    let medium: String
    let small: String
    let template: String
    
    init?(_ json: JSON) {
        guard let large = json["large"].string,
            let medium = json["medium"].string,
            let small = json["small"].string,
            let template = json["template"].string else {
                return nil
        }
        
        self.large = large
        self.medium = medium
        self.small = small
        self.template = template
    }
}
