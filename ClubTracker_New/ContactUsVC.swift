//
//  ContactUsVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/15/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Button Action
extension ContactUsVC{
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    

}
