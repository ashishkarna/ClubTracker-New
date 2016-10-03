//
//  MessageDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    
    @IBOutlet weak var lblNavTitle: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblSubject: UILabel!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.lblNavTitle.text = navTitle
    }

}

extension MessageDetailViewController{

    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}

