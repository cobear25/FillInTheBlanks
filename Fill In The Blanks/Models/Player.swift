//
//  Player.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/21/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class Player {
    var id: String = ""
    var name: String
    var image: UIImage
    required init() {
        // generate random id
        self.id = newId()
        self.name = UserDefaults.standard.string(forKey: "displayname") ?? "Me"
        self.image = UIImage(named: avatarNames[myAvatarIndex]) ?? #imageLiteral(resourceName: "bear")
    }

    init(id: String, name: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.image = image ?? #imageLiteral(resourceName: "bear")
    }
}
