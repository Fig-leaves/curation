//
//  CharaTableViewCell.swift
//  Curation
//
//  Created by 伊藤総一郎 on 2/4/16.
//  Copyright © 2016 susieyy. All rights reserved.
//

import UIKit

class CharaTableViewCell: UITableViewCell {

    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monsterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
