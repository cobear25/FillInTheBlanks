//
//  HomeViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var playLocalButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        playLocalButton.layer.cornerRadius = playLocalButton.bounds.height / 2
        playOnlineButton.layer.cornerRadius = playOnlineButton.bounds.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
