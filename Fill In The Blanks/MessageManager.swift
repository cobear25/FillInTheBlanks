//
//  MessageManager.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 1/18/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Foundation

class MessageManager: NSObject {
    
    static func blankOutMessage(message: String, count: Int) -> (NSAttributedString, [Int]) {
        let newString = message.trimmingCharacters(in: .whitespacesAndNewlines)
        var words = newString.components(separatedBy: .whitespaces)
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
        for index in indexesUsed {
            words[index] = blankString
        }
        print(words)
        print(indexesUsed)
        let attributedString = NSMutableAttributedString(string: "")
        var firstBlank = true
        for (index, word) in words.enumerated() {
            if word == blankString {
                var color = UIColor.appPurpleLight
                if firstBlank {
                    color = UIColor.appPurple
                    firstBlank = false
                }
                attributedString.append(NSAttributedString(string: word + (index == words.count ? "" : " "), attributes: [NSAttributedStringKey.foregroundColor: color]))
            } else {
                attributedString.append(NSAttributedString(string: word + (index == words.count ? "" : " ")))
            }
        }

        return (attributedString, indexesUsed.sorted())
    }
    
    static func sentenceWithNewWords(realSentence: String, blanks: [Int], newWords: [String], current: Int) -> NSAttributedString {
        let words = realSentence.components(separatedBy: .whitespaces)
        let attributedString = NSMutableAttributedString(string: "")
        var nextNewWord = 0
        for (index, word) in words.enumerated() {
            var colored = false
            var string = word
            if blanks.contains(index) {
                colored = true
                string = newWords[nextNewWord]
                nextNewWord += 1
            }
            if colored {
                // If the new word is the current one, make it dark purple
                if nextNewWord - 1 == current {
                    attributedString.append(NSAttributedString(string: string + (index == words.count ? "" : " "), attributes: [NSAttributedStringKey.foregroundColor: UIColor.appPurple]))
                } else {
                    attributedString.append(NSAttributedString(string: string + (index == words.count ? "" : " "), attributes: [NSAttributedStringKey.foregroundColor: UIColor.appPurpleLight]))
                }
            } else {
                attributedString.append(NSAttributedString(string: string + (index == words.count ? "" : " ")))
            }
        }
        return attributedString
    }
    
    static func newSentence(oldSentence: String, blanks: [Int], newWords: [String]) -> String {
        let newString = oldSentence.trimmingCharacters(in: .whitespacesAndNewlines)
        var words = newString.components(separatedBy: .whitespaces)
        var _newWords = newWords
        for index in blanks {
            words[index] = _newWords[0]
            _newWords = Array(_newWords[1...])
        }
        let newSentence = words.reduce(into: "") { (result, string) in
            result += " \(string)"
        }
        return newSentence
    }
}
