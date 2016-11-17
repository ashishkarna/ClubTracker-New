//
//  InboxViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var tableInbox: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    var inboxMessageList = [Inbox]()
    var club_id = ""
    var class_id = ""
    var child_id = ""
    var isTeacher = false
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name" : "child_name") as? String
        child_id = (UserDefaults.standard.value(forKey: "child_id") as? String)!
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!

        
        tableInbox.register(UINib(nibName: "InboxMessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InboxCell")
        Helper.setTableViewDesign(tableInbox)
        tableInbox.isHidden = true
        
        var params = [String: AnyObject]()
        params["club_id"] = club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?
        if !isTeacher{
           params["child_id"] = child_id as AnyObject?
        }
        getInbox(params)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      
}



//Button Action

extension InboxViewController{
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
        
    @IBAction func btnSearchTextTapped(_ sender: UIButton) {
        
        if Helper.isNotBlank(txtSearch.text!){
            var params = [String: AnyObject]()
            params["club_id"] = club_id as AnyObject?
            params["class_id"] = class_id as AnyObject?
            if !isTeacher{
                params ["child_id"] = child_id as AnyObject?
            }
            params["search_text"] = txtSearch.text! as AnyObject?
            getInbox(params)
            
        }

    }
    
    
}


//MARK: TableView Delegate
extension InboxViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inboxMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxMessageTableViewCell
        cell.lblTo.text = " From: "
        cell.lblDate.text = " Date: "
        cell.lblSubject.text = " Subject: "
        cell.lblTime.text = " Time: "
        if (inboxMessageList[indexPath.row].from_name) != nil{
            cell.lblTo.text =  cell.lblTo.text! + inboxMessageList[indexPath.row].from_name!
        }
        
        cell.lblDate.text = cell.lblDate.text! + Helper.getDate(inboxMessageList[indexPath.row].created_at!)
        
        if (inboxMessageList[indexPath.row].subject) != nil{
            cell.lblSubject.text = cell.lblSubject.text! + inboxMessageList[indexPath.row].subject!
        }
        
        cell.lblTime.text = cell.lblTime.text! + Helper.getTime(inboxMessageList[indexPath.row].created_at!)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Inbox"
        detailVC.inboxMessageDetail = inboxMessageList[indexPath.row]
      
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}

//MARK: View Controller Helper Method
extension InboxViewController{
    func setInbox(_ data: [AnyObject]){
         inboxMessageList.removeAll()
        for singleItem in data{
            
            let item = singleItem as! [String:AnyObject]
            let singleInbox = Inbox()
            singleInbox.id = item["id"] as? Int
            singleInbox.identifier = item["identifier"] as? String
            singleInbox.class_id = item["class_id"] as? String
            singleInbox.club_id = item["club_id"] as? String
            singleInbox.message_to = item["message_to"] as? String
            singleInbox.subject = item["subject"] as? String
            singleInbox.message = item["message"] as? String
            singleInbox.watched = item["watched"] as? String
            singleInbox.reminder = item["reminder"] as? String
            singleInbox.message_from = item["message_from"] as? String
            singleInbox.from_name = item["from_name"] as? String
            singleInbox.created_at = item["created_at"] as? String
            
            inboxMessageList.append(singleInbox)
            
        }
        if inboxMessageList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(inboxMessageList.count * 45)
        }
       tableInbox.isHidden = false
        
    }
    
}


//MARK: Web Service Helper Method
extension InboxViewController{
    
    
    func getInbox(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getTeacherInbox(params, url: (isTeacher ? kGetTeacherInboxUrl: kGetParentInboxUrl),onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let inboxList = responseResult["inboxMessages"] as? [AnyObject]
                                if (inboxList?.count)! > 0{
                                    self?.setInbox(inboxList!)
                                    self!.tableInbox.reloadData()
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
                        }
                        
                    case 301: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
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







