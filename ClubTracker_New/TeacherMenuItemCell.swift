//
//  TeacherMenuItemCell.swift
//  ClubTracker
//
//  Created by Mohan Singh Thagunna on 8/17/16.
//  Copyright © 2016 CreatuDevelopers. All rights reserved.
//

import UIKit

class TeacherMenuItemCell: UICollectionViewCell {

    //MARK: --Outlets
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var imgScoreBG: UIImageView!
    @IBOutlet weak var lblScore: UILabel!
    
    //MARK: --Cell Property
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
