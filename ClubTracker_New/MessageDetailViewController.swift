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
    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblSubject: UILabel!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var txtViewMessageDetails: UITextView!
    var navTitle: String?
   
    var outboxMessageDetail = Outbox()
    var inboxMessageDetail = Inbox()
 
    var isOutbox = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        
        lblFrom.text = isOutbox ? "To: " : "From: "
        lblDate.text = "Date: "
        lblSubject.text = "Subject: "
        lblTime.text = "Time: "

        
        if isOutbox{
        
            //outbox message detail
         if (outboxMessageDetail.message_to) != nil{
                lblFrom.text =  lblFrom.text! + outboxMessageDetail.message_to!
            
                }
            
                lblDate.text = lblDate.text! + Helper.getDate(outboxMessageDetail.created_at!)
            
                if (outboxMessageDetail.subject) != nil{
                    lblSubject.text = lblSubject.text! + outboxMessageDetail.subject!
                }
            
                lblTime.text = lblTime.text! + Helper.getTime(outboxMessageDetail.created_at!)
            
            if (outboxMessageDetail.message) != nil{
                txtViewMessageDetails.text = txtViewMessageDetails.text! + outboxMessageDetail.message!
            }
        
        }
        else{
        
        //inbox message detail
            if (inboxMessageDetail.from_name) != nil{
                lblFrom.text =  lblFrom.text! + inboxMessageDetail.from_name!
            }
            
            lblDate.text = lblDate.text! + Helper.getDate(inboxMessageDetail.created_at!)
            
            if (inboxMessageDetail.subject) != nil{
                lblSubject.text = lblSubject.text! + inboxMessageDetail.subject!
            }
            
            lblTime.text = lblTime.text! + Helper.getTime(inboxMessageDetail.created_at!)
        }
        
        
        
    
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

