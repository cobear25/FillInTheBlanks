//
//  ViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 1/18/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Cartography
import Hero

enum GameState {
    case enterMessage
    case addWords
}

let blankString = "_____"

class GameViewController: UIViewController {
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField: CMTextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var blanksCount = 3
    var sentence: String = ""
    var blanks: [Int] = []
    var textFields: [UITextField] = []
    var realSentence = ""
    var current = 0
    var newWords: [String] = []
    var gameState: GameState = .enterMessage
    let buttonWidth: CGFloat = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true

        realSentence = messageLabel.text!
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        backButtonWidthConstraint.constant = 0
        nextButton.isEnabled = false
        instructionsLabel.text = "Type a message to share"
        textField.autocapitalizationType = .sentences
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    @IBAction func sendTapped(_ sender: Any) {
        if !textField.text!.isEmpty {
            switch gameState {
            case .enterMessage:
                // grab the typed message
                realSentence = messageLabel.text!
                // get a sentence with blanks from the message
                let (sentence, blanks) = MessageManager.blankOutMessage(message: realSentence, count: blanksCount)
                self.sentence = sentence.string//String(describing: sentence)
                self.blanks = blanks
                // fill 'newWords' with underlines
                for _ in 1...blanksCount { newWords.append(blankString) }
                // set the label to the sentence with blanks
                messageLabel.attributedText = sentence
                // setup for addWords game mode
                current = 0
                textField.text = ""
                gameState = .addWords
                nextButton.isEnabled = false
                instructionsLabel.text = "Fill in the blanks with your own words"
                textField.resignFirstResponder()
                textField.autocapitalizationType = .none
                textField.becomeFirstResponder()
            case .addWords:
                if current == blanksCount - 1 {
                    // send out message
                    print("done!")
                } else {
                    current += 1
                    self.messageLabel.attributedText = MessageManager.sentenceWithNewWords(realSentence: realSentence, blanks: blanks, newWords: newWords, current: current)
                    // set the textfield text to be the typed word if it exists
                    textField.text = newWords[current] == blankString ? "" : newWords[current].trimmingCharacters(in: .whitespaces)
                    if blanksCount > 1 {
                        backButtonWidthConstraint.constant = buttonWidth
                    }
                    // If there is text in the new field don't disable button
                    nextButton.isEnabled = textField.text!.isEmpty ? false : true
                    // If going to last blank but already has text, update the instructions
                    instructionsLabel.text = "Fill in the blanks with your own words"
                    if !textField.text!.isEmpty && current == blanksCount - 1 {
                        instructionsLabel.text = "Submit the message to the next person"
                    }
                }
            }
            if current == blanksCount - 1 {
                // Last item, change next button
                nextButton.setImage(#imageLiteral(resourceName: "btn-done"), for: .normal)
                nextButton.setImage(#imageLiteral(resourceName: "btn-done-disabled"), for: .disabled)
                nextButton.setImage(#imageLiteral(resourceName: "btn-done-disabled"), for: .highlighted)
            } else {
                nextButton.setImage(#imageLiteral(resourceName: "btn-next"), for: .normal)
                nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .disabled)
                nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .highlighted)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        if current > 0 {
            // set the next button to "next"
            nextButton.setImage(#imageLiteral(resourceName: "btn-next"), for: .normal)
            nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .disabled)
            nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .highlighted)
            nextButton.isEnabled = true
            // set the blank back to an underline
            if textField.text!.isEmpty {
                newWords[current] = blankString
            }
            current -= 1
            // Update the text with the new current so it's highlighted in the correct place
            self.messageLabel.attributedText = MessageManager.sentenceWithNewWords(realSentence: realSentence, blanks: blanks, newWords: newWords, current: current)
            textField.text = newWords[current]
            // if going back to the first blank, hide the back button
            if current <= 0 {
                backButtonWidthConstraint.constant = 0
            }
            instructionsLabel.text = "Fill in the blanks with your own words"
        }
    }
    @IBAction func nextKeyTapped(_ sender: CMTextField) {
        if !sender.text!.isEmpty {
            sendTapped(nextButton)
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        if !textField.text!.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        
        switch gameState {
        case .enterMessage:
            self.messageLabel.text = textField.text!
        case .addWords:
            if newWords.count > current {
                instructionsLabel.text = "Fill in the blanks with your own words"
                // set back to underlines if no text
                if textField.text!.isEmpty {
                    newWords[current] = blankString
                } else {
                    newWords[current] = textField.text!.trimmingCharacters(in: .whitespaces)
                    // if last word has text, update instructions
                    if current == blanksCount - 1 {
                        instructionsLabel.text = "Submit the message to the next person"
                    }
                }
                self.messageLabel.attributedText = MessageManager.sentenceWithNewWords(realSentence: realSentence, blanks: blanks, newWords: newWords, current: current)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
