//
//  ChatMessageCell.swift
//  ClubTracker
//
//  Created by ashish karna on 11/25/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSentMessage: UILabel!

    @IBOutlet weak var lblOtherName: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
