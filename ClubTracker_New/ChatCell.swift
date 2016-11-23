//
//  ChatCell.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/24/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var lblChatMessage: UILabel!
    
 
    @IBOutlet weak var leadingSpaceConstant: NSLayoutConstraint!
    
    @IBOutlet weak var trailingSpaceConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
