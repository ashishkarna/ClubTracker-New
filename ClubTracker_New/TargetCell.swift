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
    
    @IBOutlet weak var btnComplete: UIButton!
    
    var target_id : String?
    var Status: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func customizeCompleteButton(status:Int){
        if status == 1{
            btnComplete.backgroundColor = appColor
        
        }
        else{
            btnComplete.backgroundColor = lightAppColor
        }
    }
}
