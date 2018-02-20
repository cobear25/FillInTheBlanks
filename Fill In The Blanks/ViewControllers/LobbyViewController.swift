//
//  LobbyViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Hero
import MultipeerConnectivity

class Player {
    var id: String = ""
    var name: String
    var image: UIImage
    required init() {
        // generate random id
        self.id = newId()
        self.name = UserDefaults.standard.string(forKey: "displayname") ?? "Me"
        self.image = UIImage(named: avatarNames[myAvatarIndex]) ?? #imageLiteral(resourceName: "bear")
    }

    init(id: String, name: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.image = image ?? #imageLiteral(resourceName: "bear")
    }
}

class LobbyViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var me = Player()
    var players: [Player] = []
    var hosting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        players = [me]
        isHeroEnabled = true
        hideKeyboardWhenTappedAround()

        startButton.layer.cornerRadius = startButton.bounds.height / 2
        tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        LocalServiceManager.shared.delegate = self
        startButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        LocalServiceManager.shared.stop()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        LocalServiceManager.shared.startGame()
        proceed()
    }
    
    func proceed() {
        LocalServiceManager.shared.inGame = true
        LocalServiceManager.shared.delegate = nil
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
        LocalServiceManager.shared.updateName(name: textField.text!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LobbyViewController: LocalServiceDelegate {
    func connectedDevicesChanged(manager: LocalServiceManager, connectedDevices: [String]) {
        var otherPlayers: [Player] = [me]
        for peer in manager.session.connectedPeers {
            let displayName = peer.displayName
            otherPlayers.append(Player(id: displayName, name: String(displayName.dropLast(uniqueId.count + 2)), image: UIImage(named: avatarNames[Int(peer.displayName.suffix(2))!])))
        }
        self.players = otherPlayers
        DispatchQueue.main.async {
            if self.hosting && self.players.count > 1 {
                self.startButton.isEnabled = true
            } else {
                self.startButton.isEnabled = false
            }
            self.tableView.reloadData()
        }
    }

    func updatedNameFromPeer(peer: MCPeerID, name: String) {
        for player in self.players {
            if player.id == peer.displayName {
                player.name = name
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func avatarIndexFromPeer(peer: MCPeerID, index: Int) {
        for player in self.players {
            if player.id == peer.displayName {
                player.image = UIImage(named: avatarNames[index]) ?? #imageLiteral(resourceName: "bear")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func hostDisconnected() {
        DispatchQueue.main.async {
            self.backButtonTapped(self.backButton)
        }
    }
    
    func gameStarted(started: Bool) {
        if started {
            DispatchQueue.main.async {
                self.proceed()
            }
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


