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
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        hideKeyboardWhenTappedAround()

        joinButton.layer.cornerRadius = joinButton.bounds.height / 2
        hostButton.layer.cornerRadius = hostButton.bounds.height / 2
        alertView.layer.cornerRadius = 35
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.5
        alertTextField.layer.cornerRadius = alertTextField.bounds.height / 2
        alertTextField.delegate = self
        alertTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }
    
    func showAlert() {
        alertView.isHidden = false
        alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    func hideAlert() {
        alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.1, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.alertView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { _ in
                self.alertView.isHidden = true
            })
        })
    }


    func askForName() {
        if UserDefaults.standard.string(forKey: "displayname") == nil {
            // show name view
            showAlert()
            joinButton.isEnabled = false
            hostButton.isEnabled = false
        } else {
            // proceed
            proceed()
        }
    }

    func proceed() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LobbyViewController") as! LobbyViewController
        UserDefaults.standard.set(randomAvatarIndex, forKey: EventKey.avatarIndex)
        if hosting {
            LocalServiceManager.shared.host()
        } else {
            LocalServiceManager.shared.join()
        }
        vc.hosting = hosting
        show(vc, sender: self)
    }
    @IBAction func hostTapped(_ sender: Any) {
        hosting = true
        askForName()
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        hosting = false
        askForName()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        if alertTextField.text!.isEmpty {
            joinButton.isEnabled = false
            hostButton.isEnabled = false
        } else {
            joinButton.isEnabled = true
            hostButton.isEnabled = true
            UserDefaults.standard.set(alertTextField.text!, forKey: "displayname")
        }
    }
    
    @IBAction func textfieldDone(_ sender: Any) {
        alertTextField.resignFirstResponder()
    }
}

extension HostJoinViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
