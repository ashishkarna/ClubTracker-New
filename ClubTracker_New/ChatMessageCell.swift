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
        
        
        lblSentMessage.layer.shadowColor = UIColor.black.cgColor
        lblSentMessage.layer.shadowOffset = CGSize(width: 0, height: 4)
        lblSentMessage.layer.shadowOpacity = 0.2
        
        lblSentMessage.layer.borderColor = UIColor.lightGray.cgColor
      
        lblSentMessage.layer.borderWidth = 1.0
        lblSentMessage.layer.cornerRadius = 2.0
        lblSentMessage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
