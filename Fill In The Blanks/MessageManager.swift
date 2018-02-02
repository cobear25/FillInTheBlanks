//
//  MessageManager.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 1/18/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class MessageManager: NSObject {
    
    static func blankOutMessage(message: String, count: Int) -> ([String], [Int]) {
        let newString = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = newString.components(separatedBy: .whitespaces)
        var indexesUsed: [Int] = []
        var newCount = count
        // Prevent the loop from never ending by setting the count to the length of the string if too long.
        if words.count < count {
            newCount = words.count
        }
        while indexesUsed.count < newCount {
            let index = arc4random_uniform(UInt32(words.count))
            if !indexesUsed.contains(Int(index)) {
                indexesUsed.append(Int(index))
            }
        }
        print(words)
        print(indexesUsed)

        return (words, indexesUsed)
    }

}
