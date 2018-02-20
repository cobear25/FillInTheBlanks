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
import MultipeerConnectivity

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
    var receivedMessages: [String] = []
    var currentMessageIndex = 0
    var waiting = false
    var peerArray: [MCPeerID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        LocalServiceManager.shared.messagesDelegate = self

        realSentence = messageLabel.text!
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        backButtonWidthConstraint.constant = 0
        nextButton.isEnabled = false
        instructionsLabel.text = "Type a message to share"
        textField.autocapitalizationType = .sentences

        peerArray = LocalServiceManager.shared.session.connectedPeers
        peerArray.append(LocalServiceManager.shared.getPeerId())
        peerArray = peerArray.sorted(by: { $0.displayName > $1.displayName })
        while peerArray[0] != LocalServiceManager.shared.getPeerId() {
            peerArray.rotate(positions: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    @IBAction func sendTapped(_ sender: Any) {
        if !textField.text!.isEmpty {
            switch gameState {
            case .enterMessage:
                LocalServiceManager.shared.sendMessageToPeer(peer: peerArray[1], message: messageLabel.text!)
                messageLabel.text = "Waiting for message..."
                current = 0
                textField.text = ""
                gameState = .addWords
                // load received message
                if receivedMessages.count > currentMessageIndex {
                    loadMessage()
                } else {
                    print("waiting for next message")
                    resetUI()
                    waiting = true
                }
            case .addWords:
                if current == blanksCount - 1 {
                    // send out message
                    currentMessageIndex += 1
                    // send message to next peer
                    LocalServiceManager.shared.sendMessageToPeer(peer: peerArray[1], message: messageLabel.text!)
                    // go to results if done
                    if currentMessageIndex >= peerArray.count - 1 {
                        print("that's all folks")
                        resetUI()
                        return
                    }
                    // load received message
                    if receivedMessages.count > currentMessageIndex {
                        loadMessage()
                    } else {
                        messageLabel.text = "Waiting for message..."
                        print("waiting for next message")
                        resetUI()
                        waiting = true
                    }
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
    
    func loadMessage() {
        waiting = false
        newWords.removeAll()
        // grab the typed message
        realSentence = receivedMessages[currentMessageIndex]
        // get a sentence with blanks from the message
        let (sentence, blanks) = MessageManager.blankOutMessage(message: realSentence, count: blanksCount)
        self.sentence = sentence.string
        self.blanks = blanks
        // fill 'newWords' with underlines
        for _ in 1...blanksCount { newWords.append(blankString) }
        // set the label to the sentence with blanks
        messageLabel.attributedText = sentence
        // setup for addWords game mode
        current = 0
        textField.text = ""
        textField.isEnabled = true
        backButtonWidthConstraint.constant = 0
        gameState = .addWords
        nextButton.isEnabled = false
        instructionsLabel.text = "Fill in the blanks with your own words"
        textField.resignFirstResponder()
        textField.autocapitalizationType = .none
        textField.becomeFirstResponder()
    }
    
    func resetUI() {
        textField.text = ""
        textField.isEnabled = false
        backButtonWidthConstraint.constant = 0
        nextButton.setImage(#imageLiteral(resourceName: "btn-next"), for: .normal)
        nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .disabled)
        nextButton.setImage(#imageLiteral(resourceName: "btn-next-disabled"), for: .highlighted)
        nextButton.isEnabled = false
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

extension GameViewController: MessagesDelegate {
    func messageReceived(message: String) {
        DispatchQueue.main.async {
            if self.receivedMessages.count >= self.peerArray.count - 1 {
                self.receivedMessages.append(message)
                print(self.receivedMessages)
            } else {
                self.receivedMessages.append(message)
                if self.waiting {
                    self.loadMessage()
                }
            }
        }
    }
}
