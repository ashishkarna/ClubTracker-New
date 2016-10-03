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
    
    
    
  var buttonState = [false,false,false]
    
    //MARK:--tableViewcell property
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureButtonState(data:[Bool]){
        
       //button in
        
        if data[0]{
            btnIn.backgroundColor = appColor
        }
        else{
            btnIn.backgroundColor = lightAppColor
        }
        
        //button abs
        if data[1]{
            btnAbs.backgroundColor = appColor
        }
        else{
            btnAbs.backgroundColor = lightAppColor
        }
        
        //button late
        if data[2]{
            btnLate.backgroundColor = appColor
        }
        else{
            btnLate.backgroundColor = lightAppColor
        }
        
        
        }
    
    
    @IBAction func btnTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if buttonState[0] {
                buttonState[0] = false
                
            }
            else{
                buttonState[0] = true
                buttonState[1] = false
                buttonState[2] = false
             
            }
            
        case 1:
            if buttonState[1] {
                buttonState[1] = false
            
            }
            else{
                buttonState[1] = true
                buttonState[0] = false
                buttonState[2] = false
            }
            
        case 2:
            if buttonState[2] {
                buttonState[2] = false
            }
            else{
                buttonState[2] = true
                buttonState[1] = false
                buttonState[0] = false
            }
        default:
            break
        }
        
        configureButtonState(buttonState)
        
        
    }
    
}
