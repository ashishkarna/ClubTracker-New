//
//  UrgentMessageDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/6/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UrgentMessageDetailViewController: UIViewController {

    @IBOutlet weak var imgClubLogo: UIImageView!
    
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
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var btnOutletUpdate: UIButton!
    @IBOutlet weak var viewParentButton: UIView!
    @IBOutlet weak var topSapceConstraint: NSLayoutConstraint!
    
    
    var navTitle: String?
    var urgentMessageDetail = UrgentRequest()
    var isTeacher = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //outbox message detail
        
        
         lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name": "child_name") as? String
        
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
        if urgentMessageDetail.event_time != nil {
           lblTime.text = lblTime.text! + Helper.getSimpleTime(urgentMessageDetail.event_time!)
        }
        
        lblPickUpPoint.text = lblPickUpPoint.text! + urgentMessageDetail.pickup_point!
        
    
        if isTeacher {
            lblReminder.text = lblReminder.text! + urgentMessageDetail.reminder! + " Days"
            lblResponded.text = lblResponded.text! + String(urgentMessageDetail.responded_percent!) + " %"
            let outstandingPeople = String(urgentMessageDetail.responded_percent! * 1)
            lblOutstanding.text = lblOutstanding.text! + outstandingPeople + " People"
           viewParentButton.alpha = 0
            
        }
        else{
            viewParentButton.alpha = 1
          lblReminder.removeFromSuperview()
          lblOutstanding.removeFromSuperview()
            //top space
           NSLayoutConstraint(item: viewParentButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: lblPickUpPoint, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 15.0).isActive = true
            //leading
           NSLayoutConstraint(item: viewParentButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: lblPickUpPoint, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0).isActive = true
           //width
          NSLayoutConstraint(item: viewParentButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: lblPickUpPoint, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0).isActive = true
            //height
          NSLayoutConstraint(item: viewParentButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: lblPickUpPoint, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0).isActive = true
            self.view.layoutIfNeeded()

        }
  

        if Helper.getUserInfo()?.avatar_link != nil{
            Helper.loadImageFromUrl(url: (Helper.getUserInfo()?.avatar_link!)!, view: imgClubLogo)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    }


//MARK: Button Action
extension UrgentMessageDetailViewController{
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func btnUpdateAndRemind(_ sender: UIButton) {
    }
    
    @IBAction func btnAcceptOrDeclinePressed(_ sender: UIButton) {
        
        
        
    }
    
    

}




