//
//  HelpVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/17/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //(self.navigationController?.tabBarController as! TabBarController)
    }
    

   
}

//MARK: Button Action
extension HelpVC{

    @IBAction func btnBack(sender: UIButton) {
        
        
        
    }

}
