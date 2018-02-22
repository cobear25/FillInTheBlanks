//
//  ResultsViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/21/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Hero

class ResultsViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true

        doneButton.layer.cornerRadius = doneButton.bounds.height / 2

        var string = ""
        string += "Results:\n"
        for message in messages {
        string += "     \(message.originalSender)'s results:\n"
            for m in message.messages {
                string += "          \(m)\n"
            }
        }
        resultsLabel.text = string
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        LocalServiceManager.shared.stop()
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
}
