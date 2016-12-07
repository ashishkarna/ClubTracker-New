//
//  sizeQtyCell.swift
//  ClubTracker
//
//  Created by Mohan on 12/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class sizeQtyCell: UITableViewCell {

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblSizeQty: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(size:String,qty:String)
    {
        lblQuantity.text = qty
        lblSizeQty.text = size
    }
    
}
