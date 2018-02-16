//
//  LobbyViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Hero

class Player {
    var id: String = ""
    var name: String
    var image: UIImage
    required init() {
        // generate random id
        self.id = newId()
        self.name = UserDefaults.standard.string(forKey: "displayname") ?? "Me"
        self.image = UIImage(named: avatarNames[UserDefaults.standard.integer(forKey: EventKey.avatarIndex)]) ?? #imageLiteral(resourceName: "bear")
    }

    init(id: String, name: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.image = image ?? #imageLiteral(resourceName: "bear")
    }
}

class LobbyViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var players: [Player] = [Player()]
    var hosting = false

    override func viewDidLoad() {
        super.viewDidLoad()

        isHeroEnabled = true
        hideKeyboardWhenTappedAround()

        startButton.layer.cornerRadius = startButton.bounds.height / 2
        tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        LocalServiceManager.shared.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController")
        show(vc, sender: self)
    }
}

extension LobbyViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PlayerTableViewCell
        let player = players[indexPath.row]
        cell.selectionStyle = .none
        cell.nameLabel.text = player.name
        cell.nameField.text = player.name
        cell.avatarImageView.image = player.image
        if indexPath.row == 0 {
            cell.nameField.delegate = self
            cell.editIcon.isHidden = false
        } else {
            cell.editIcon.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! PlayerTableViewCell
            cell.nameLabel.isHidden = true
            cell.nameField.isHidden = false
            cell.editIcon.isHidden = true
            cell.nameField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension LobbyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PlayerTableViewCell
        cell.nameLabel.text = textField.text!
        cell.nameLabel.isHidden = false
        cell.nameField.isHidden = true
        cell.editIcon.isHidden = false
        players.first?.name = textField.text!
        UserDefaults.standard.set(textField.text!, forKey: "displayname")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LobbyViewController: LocalServiceDelegate {
    func connectedDevicesChanged(manager: LocalServiceManager, connectedDevices: [String]) {
//        for name in connectedDevices {
//            players.append(Player(id: name, name: name, image: UIImage(named: avatarNames[UserDefaults.standard.integer(forKey: EventKey.avatarIndex)]) ?? #imageLiteral(resourceName: "bear")))
//        }
        var otherPlayers: [Player] = [Player()]
        for peer in manager.session.connectedPeers {
            otherPlayers.append(Player(id: newId(), name: peer.displayName, image: UIImage(named: avatarNames[UserDefaults.standard.integer(forKey: EventKey.avatarIndex)]) ?? #imageLiteral(resourceName: "bear")))
        }
        self.players = otherPlayers
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


