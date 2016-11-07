//
//  UrgentMessageViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UrgentMessageViewController: UIViewController {

    
    @IBOutlet weak var lblClassName: UILabel!
    
    
    @IBOutlet weak var tableUrgentRequest: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
 
    var urgentMessageList = [UrgentRequest]()
    var club_id = ""
    var class_id = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!
        
        tableUrgentRequest.registerNib(UINib(nibName: "MessageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MessageCell")
        
        Helper.setTableViewDesign(tableUrgentRequest)
    }

    override func viewWillAppear(animated: Bool) {
        tableUrgentRequest.hidden = true
        
        var params = [String: AnyObject]()
        params["club_id"] = club_id
        params["class_id"] = class_id
        getUrgentRequest(params)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//Button Action

extension UrgentMessageViewController{

    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func btnSwitchTapped(sender: UISwitch) {
        var params = [String: AnyObject]()
        params["club_id"] = club_id
        params["class_id"] = class_id
       
        if sender.on{
            
            getCompletedRequest(params)
        }
        
        else{
            getUrgentRequest(params)
            
        
        }
    }

    
    
}

extension UrgentMessageViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urgentMessageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
          let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageTableViewCell
        cell.lblTo.text = " From: "
        cell.lblDeadline.text = " Deadline: "
        cell.lblSubject.text = " Subject: "
        cell.lblResponded.text = " Responded: "
        if (urgentMessageList[indexPath.row].message_to) != nil{
            cell.lblTo.text =  cell.lblTo.text! + urgentMessageList[indexPath.row].message_to!
        }
        
        cell.lblDeadline.text = cell.lblDeadline.text! + Helper.getDate(urgentMessageList[indexPath.row].deadline!)
        
        if (urgentMessageList[indexPath.row].subject) != nil{
            cell.lblSubject.text = cell.lblSubject.text! + urgentMessageList[indexPath.row].subject!
        }
        
        cell.lblResponded.text = cell.lblResponded.text! + String(urgentMessageList[indexPath.row].responded_percent! ) + "%"
 
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = UrgentMessageDetailViewController(nibName: "UrgentMessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Urgent"
        detailVC.urgentMessageDetail = urgentMessageList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}



//MARK: View Controller Helper Method
extension UrgentMessageViewController{
    func setUrgent(data: [AnyObject]){
        urgentMessageList.removeAll()
        for singleItem in data{
            
            let item = singleItem as! [String:AnyObject]
            let singleUrgent = UrgentRequest()
            singleUrgent.identifier = item["identifier"] as? String
            singleUrgent.class_id = item["class_id"] as? String
            singleUrgent.club_id = item["club_id"] as? String
            singleUrgent.subject = item["subject"] as? String
            singleUrgent.message = item["message"] as? String
            singleUrgent.is_urgent = item["is_urgent"] as? String
            singleUrgent.deadline = item["deadline"] as? String
            singleUrgent.cost = item["cost"] as? String
            singleUrgent.event_date = item["event_date"] as? String
            singleUrgent.pickup_point = item["pick_point"] as? String
            singleUrgent.reminder = item["reminder"] as? String
            singleUrgent.message_to = item["message_to"] as? String
            singleUrgent.created_at = item["created_at"] as? String
            singleUrgent.responded_percent = item["responded_percent"] as? Int
            
            urgentMessageList.append(singleUrgent)
            
        }
        if urgentMessageList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(urgentMessageList.count * 45)
        }
        tableUrgentRequest.hidden = false
        self.tableUrgentRequest.reloadData()
    }
    
}



//MARK: Web Service Helper Method
extension UrgentMessageViewController{
    
    
    func getUrgentRequest(params: [String: AnyObject]){
        
        MBProgressHUD.showHUDAddedTo(self.tableUrgentRequest, animated: true)
        WebServiceHelper.getTeacherRequests(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDsForView(self?.tableUrgentRequest, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let urgentList = responseResult["requests"] as? [AnyObject]
                                if urgentList?.count > 0{
                                    self?.setUrgent(urgentList!)
                                    
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
                        }
                        
                    case 301: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.Failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            
            
            
            })
        
    }
    
    
    
    func getCompletedRequest(params: [String: AnyObject]){
        
        MBProgressHUD.showHUDAddedTo(self.tableUrgentRequest, animated: true)
        WebServiceHelper.completedAllPriorRequests(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDsForView(self?.tableUrgentRequest, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        self?.showAlertOnMainThread("All Prior Request has been archived.")
                        self?.urgentMessageList.removeAll()
                        self?.tableUrgentRequest.reloadData()
                        
                    case 301: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
        
            case.Failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            
            
            
            })
        
    }

    
}


