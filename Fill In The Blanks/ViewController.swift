//
//  ViewController.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 1/18/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var words: [String] = []
    var blanks: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let (words, blanks) = MessageManager.blankOutMessage(message: "This is the voice. ", count: 1)
//        MessageManager.blankOutMessage(message: "I know that, that's wrong!  ", count: 2)
//        MessageManager.blankOutMessage(message: " When, I, am , good.", count: 3)
//        MessageManager.blankOutMessage(message: "a n sad fdsa;afd fd!@3", count: 4)
//        MessageManager.blankOutMessage(message: "the end", count: 5)
//        print(words)

        collectionView.register(UINib.init(nibName: "WordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 150, height: 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendTapped(_ sender: Any) {
        self.words = []
        self.blanks = []
        collectionView.reloadData()
        let (words, blanks) = MessageManager.blankOutMessage(message: textfield.text ?? "", count: 2)
        self.words = words
        self.blanks = blanks
        collectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WordCollectionViewCell
        if blanks.contains(indexPath.row) {
            cell.label.isHidden = true
            cell.textField.isHidden = false
        } else {
            cell.label.text = words[indexPath.row]
            cell.textField.isHidden = true
            cell.label.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
}

