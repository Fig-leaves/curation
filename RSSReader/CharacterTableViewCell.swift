//
//  CharacterTableViewCell.swift
//  !
//
//  Created by NoasProject on 2016/02/01.
//  Copyright © 2016年 Noas. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var sex: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if sex.text == "男" {
            print("a")
        } else {
            print("v")
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
