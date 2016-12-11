//
//  UrgentMessageViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UrgentMessageViewController: UIViewController {

    
    
    @IBOutlet weak var imgClubLogo: UIImageView!
    
    @IBOutlet weak var lblClassName: UILabel!
    
    
    @IBOutlet weak var tableUrgentRequest: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
 
    var urgentMessageList = [UrgentRequest]()
    var club_id = ""
    var class_id = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        lblClassName.text = UserDefaults.standard.value(forKey: "class_name") as? String
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        
        tableUrgentRequest.register(UINib(nibName: "MessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        
        Helper.setTableViewDesign(tableUrgentRequest)
        tableUrgentRequest.isHidden = true
        
        var params = [String: AnyObject]()
        params["club_id"] = club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?
        getUrgentRequest(params)
        
        
        if Helper.getUserInfo()?.avatar_link != nil{
            Helper.loadImageFromUrl(url: (Helper.getUserInfo()?.avatar_link!)!, view: imgClubLogo)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//Button Action

extension UrgentMessageViewController{

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnSwitchTapped(_ sender: UISwitch) {
        var params = [String: AnyObject]()
        params["club_id"] = club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?
       
        if sender.isOn{
            
            getCompletedRequest(params)
        }
        
        else{
            getUrgentRequest(params)
            
        
        }
    }

    
    
}

extension UrgentMessageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urgentMessageList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
          let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UrgentMessageDetailViewController(nibName: "UrgentMessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Urgent"
        detailVC.isTeacher = true
        detailVC.urgentMessageDetail = urgentMessageList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}



//MARK: View Controller Helper Method
extension UrgentMessageViewController{
    func setUrgent(_ data: [AnyObject]){
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
            singleUrgent.event_time = item["event_time"] as? String
            singleUrgent.pickup_point = item["pick_point"] as? String
            singleUrgent.reminder = item["reminder"] as? String
            singleUrgent.message_to = item["message_to"] as? String
            singleUrgent.created_at = item["created_at"] as? String
            singleUrgent.responded_percent = item["responded_percent"] as? Int
            
            urgentMessageList.append(singleUrgent)
            
        }
        
        urgentMessageList.reverse()
//        if urgentMessageList.count > 6{
//            tableHeight.constant = CGFloat(6 * 45)
//        }
//        else{
//            tableHeight.constant = CGFloat(urgentMessageList.count * 45)
//        }
        tableUrgentRequest.isHidden = false
        self.tableUrgentRequest.reloadData()
    }
    
}



//MARK: Web Service Helper Method
extension UrgentMessageViewController{
    
    
    func getUrgentRequest(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getTeacherRequests(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let urgentList = responseResult["requests"] as? [AnyObject]
                                if (urgentList?.count)! > 0{
                                    self?.setUrgent(urgentList!)
                                    
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
                        }
                        
                    case 301: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            
            
            
            })
        
    }
    
    
    
    func getCompletedRequest(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.tableUrgentRequest, animated: true)
        WebServiceHelper.completedAllPriorRequests(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.tableUrgentRequest, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        self?.showAlertOnMainThread("All Prior Request has been archived.")
                        self?.urgentMessageList.removeAll()
                        self?.tableUrgentRequest.reloadData()
                        
                    case 301: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
        
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            
            
            
            })
        
    }

    
}


