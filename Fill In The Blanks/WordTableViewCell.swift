//
//  WordTableViewCell.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/8/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: CMTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
