//
//  DiaryListCell.swift
//  ClubTracker
//
//  Created by Mohan on 11/24/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class DiaryListCell: UITableViewCell {

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
