//
//  ViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 1/18/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    var sentence: String = ""
    var blanks: [Int] = []
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "WordTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendTapped(_ sender: Any) {
        var canProceed = true
        var newWords: [String] = []
        for field in textFields {
            if field.text!.isEmpty {
                canProceed = false
            }
            newWords.append(field.text!)
        }
        if canProceed {
            textFields.forEach { $0.text = "" }
            let sentenceToCreate = MessageManager.newSentence(oldSentence: messageLabel.text ?? "", blanks: self.blanks, newWords: newWords)
            let (sentence, blanks) = MessageManager.blankOutMessage(message: sentenceToCreate, count: 2)
            self.sentence = sentence
            self.blanks = blanks
            textFields.removeAll()
            tableView.reloadData()
            messageLabel.text = sentence
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WordTableViewCell
        cell.textField.characterLimit = 25
        textFields.append(cell.textField)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blanks.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

