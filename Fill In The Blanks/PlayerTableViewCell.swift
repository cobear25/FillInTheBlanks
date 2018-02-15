//
//  PlayerTableViewCell.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/14/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var editIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wrapperView.layer.cornerRadius = wrapperView.bounds.height / 2
        nameField.layer.cornerRadius = nameField.bounds.height / 2
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        nameField.leftView = leftPadding
        nameField.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
