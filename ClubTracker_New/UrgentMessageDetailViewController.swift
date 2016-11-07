//
//  UrgentMessageDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/6/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UrgentMessageDetailViewController: UIViewController {

    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var txtViewMessageDetail: UITextView!
    
    @IBOutlet weak var lblDeadlineDate: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPickUpPoint: UILabel!
    @IBOutlet weak var lblReminder: UILabel!
    
    @IBOutlet weak var lblResponded: UILabel!
    @IBOutlet weak var lblOutstanding: UILabel!
    
    
    
    var navTitle: String?
    var urgentMessageDetail = UrgentRequest()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //outbox message detail
        
         lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        
        if (urgentMessageDetail.message_to) != nil{
            lblTo.text =  lblTo.text! + urgentMessageDetail.message_to!
            
        }
        if (urgentMessageDetail.subject) != nil{
            lblSubject.text = lblSubject.text! + urgentMessageDetail.subject!
        }
        
        if (urgentMessageDetail.message) != nil{
            txtViewMessageDetail.text =  urgentMessageDetail.message!
        }
        
        
        lblDeadlineDate.text = lblDeadlineDate.text! + Helper.getDate(urgentMessageDetail.deadline!)
        lblCost.text = lblCost.text! + urgentMessageDetail.cost!
        lblDate.text = lblDate.text! + urgentMessageDetail.event_date!
        lblTime.text = lblTime.text! + Helper.getSimpleTime(urgentMessageDetail.event_date!)
        lblPickUpPoint.text = lblPickUpPoint.text! + urgentMessageDetail.pickup_point!
        lblReminder.text = lblReminder.text! + urgentMessageDetail.reminder! + " Days"
        
        lblResponded.text = lblResponded.text! + String(urgentMessageDetail.responded_percent) + " %"
    
        
        // lblTime.text = lblTime.text! + Helper.getTime(outboxMessageDetail.created_at!)
        

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    }


//MARK: Button Action
extension UrgentMessageDetailViewController{
    
    
    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    

    @IBAction func btnUpdateAndRemind(sender: UIButton) {
    }

}




