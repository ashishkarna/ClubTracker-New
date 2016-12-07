//
//  SizeAndQtyCell.swift
//  ClubTracker
//
//  Created by Mohan Singh Thagunna on 11/30/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

protocol sizeQtyCellDelegates {
    func editButtonTapped(sender:UIButton)
    func removeButtonTapped(sender:UIButton)
}
class SizeAndQtyCell: UITableViewCell {
 
    var delegate:sizeQtyCellDelegates?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var txtSize: UILabel!
    @IBOutlet weak var txtQty: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(size:String,Qty:String,index:Int){
        txtSize.text = size
        txtQty.text = Qty
        btnEdit.tag = index
        btnRemove.tag = index
    }
    @IBAction func removeButtonTapped(_ sender: Any) {
         delegate?.removeButtonTapped(sender: sender as! UIButton)
         }
    @IBAction func EditButtonTapeed(_ sender: Any) {
       
        delegate?.editButtonTapped(sender: sender as! UIButton)

    }

    
}
