//
//  MessageTableViewCell.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var lblDeadline: UILabel!
    
    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var lblResponded: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
