//
//  RegisterCell.swift
//  ClubTracker
//
//  Created by Mohan Singh Thagunna on 8/20/16.
//  Copyright © 2016 CreatuDevelopers. All rights reserved.
//

import UIKit




class RegisterCell: UITableViewCell {
//MARK: -- Outlets
    
    @IBOutlet weak var btnLate: UIButton!
    @IBOutlet weak var btnAbs: UIButton!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var lblName: UILabel!

    //var childList = [Child]()
    var status:Int!
    var didButtonTapped = false
    //MARK:--tableViewcell property
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setAttendanceStatus(status:Int){
       
        switch status {
        case 0://abs
           
            btnAbs.backgroundColor = appColor
            btnIn.backgroundColor = lightAppColor
            btnLate.backgroundColor = lightAppColor
        
        case 1://in

            btnAbs.backgroundColor = lightAppColor
            btnIn.backgroundColor = appColor
            btnLate.backgroundColor = lightAppColor
            
           
        
        case 2://late
            
            btnAbs.backgroundColor = lightAppColor
            btnIn.backgroundColor = lightAppColor
            btnLate.backgroundColor = appColor
            
        default:
            btnAbs.backgroundColor = lightAppColor
            btnIn.backgroundColor = lightAppColor
            btnLate.backgroundColor = lightAppColor

            break
        }
    }
    
    
    
    func getAttendanceStatus()->Int{
        return status!
    }
    
    
    @IBAction func btnTapped(sender: UIButton) {
        didButtonTapped = true
       
        switch sender.tag {

        case 0:     //abs
            status = 0
            
        case 1:     //in
            status = 1
            
        case 2:     //late
            status = 2
            
        default:
            break
        }
       // setAttendanceStatus(status!)
        
    }
    
}
