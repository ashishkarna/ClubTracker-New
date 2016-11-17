//
//  SocialMediaVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/15/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class SocialMediaVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: Button action method
extension SocialMediaVC{
    
    //send
    @IBAction func btnSend(_ sender: UIButton) {
    }

    //back
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Camera Button
    @IBAction func btnCamera(_ sender: UIButton) {
    }
    

    
    //MARK: Social Media
    
    ///Update on Facebook
    @IBAction func btnFacebook(_ sender: UIButton) {
    }
    
    ///Update on Twitter
    @IBAction func btnTwitter(_ sender: UIButton) {
    }
    
    ///Update on Instagram
    @IBAction func btnInstagram(_ sender: UIButton) {
    }

}
