//
//  YoutubeTableViewCell.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/13/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
