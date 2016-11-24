//
//  ChatListCell.swift
//  ClubTracker
//
//  Created by ashish karna on 11/24/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    @IBOutlet weak var lblChatName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
