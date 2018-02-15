//
//  Helpers.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import Foundation

func randomString(length: Int) -> String {

    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)

    var randomString = ""

    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }

    return randomString
}

func newId() -> String {
    return randomString(length: 10)
}
