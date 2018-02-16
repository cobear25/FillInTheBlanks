//
//  HostJoinViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/15/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Hero

class HostJoinViewController: UIViewController {
    var hosting = false

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true

        joinButton.layer.cornerRadius = joinButton.bounds.height / 2
        hostButton.layer.cornerRadius = hostButton.bounds.height / 2
    }

    func askForName() {
        if UserDefaults.standard.string(forKey: "displayName") == nil {
            // show name view
        } else {
            // proceed
        }
    }

    func proceed() {
        if hosting {
            let _ = LocalServiceManager()
        } else {

        }
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
