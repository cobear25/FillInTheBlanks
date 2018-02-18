//
//  HomeViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HomeViewController: UIViewController, MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    }

    @IBOutlet weak var playLocalButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!
    let localServiceManager = LocalServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        playLocalButton.layer.cornerRadius = playLocalButton.bounds.height / 2
        playOnlineButton.layer.cornerRadius = playOnlineButton.bounds.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onlineTapped(_ sender: Any) {
        let browserViewController = MCBrowserViewController(browser: LocalServiceManager.shared.serviceBrowser,
                                                            session: LocalServiceManager.shared.session)
        browserViewController.delegate = self
        self.present(browserViewController, animated: true) {
            LocalServiceManager.shared.serviceBrowser.startBrowsingForPeers()
        }
    }


}
