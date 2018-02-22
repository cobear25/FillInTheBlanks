//
//  Message.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/21/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class Message {
    let originalSender: String
    var messages: [String]

    required init() {
        self.originalSender = UserDefaults.standard.string(forKey: "displayname") ?? UIDevice.current.name
        self.messages = []
    }

    init(dict: [String : Any]) {
        self.originalSender = dict["originalSender"] as! String
        self.messages = dict["messages"] as! [String]
    }

    func toDict() -> [String : Any] {
        return [
            "originalSender" : self.originalSender,
            "messages" : self.messages
        ]
    }
}
