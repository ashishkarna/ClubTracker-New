//
//  TargetCell.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/14/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class TargetCell: UITableViewCell {
    
    @IBOutlet weak var targetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func btnComplete(_ sender: UIButton) {
    }
}
