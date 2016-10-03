//
//  TabBarCollectionViewCell.swift
//  Albany
//
//  Created by Ebpearls on 10/08/2016.
//  Copyright © 2016 Ashwin. All rights reserved.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var tabItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(data:String, selectedIndex: Int, row: Int) {
        
        self.tabItemLabel.text = data
      //  let imageString = data[1]
        
        if selectedIndex == row {
           // self.tabItemImage.image = UIImage(named: "\(imageString)Selected")
            self.view.backgroundColor =  appColor
            self.tabItemLabel.textColor =  UIColor(red: 0, green: 78/255, blue: 64/255, alpha: 1.0)
        }
        else{
           // self.tabItemImage.image = UIImage(named: imageString)
            self.view.backgroundColor = UIColor(red: 210/255, green: 240/255, blue: 139/255, alpha: 1.0)
            self.tabItemLabel.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
        }
        
    }

}
