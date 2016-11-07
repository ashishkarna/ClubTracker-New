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
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!

        
        tableInbox.registerNib(UINib(nibName: "InboxMessageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "InboxCell")
        Helper.setTableViewDesign(tableInbox)
    }

    
    override func viewWillAppear(animated: Bool) {
        tableInbox.hidden = true
        
        var params = [String: AnyObject]()
        params["club_id"] = club_id
        params["class_id"] = class_id
        getInbox(params)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      
}



//Button Action

extension InboxViewController{
    
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
        
    @IBAction func btnSearchTextTapped(sender: UIButton) {
        
        if Helper.isNotBlank(txtSearch.text!){
            var params = [String: AnyObject]()
            params["club_id"] = club_id
            params["class_id"] = class_id
            params["search_text"] = txtSearch.text!
            getInbox(params)
            
        }

    }
    
    
}


//MARK: TableView Delegate
extension InboxViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inboxMessageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InboxCell") as! InboxMessageTableViewCell
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Inbox"
        detailVC.inboxMessageDetail = inboxMessageList[indexPath.row]
      
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}

//MARK: View Controller Helper Method
extension InboxViewController{
    func setInbox(data: [AnyObject]){
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
            singleInbox.created_at = item["created_at"] as? String
            
            inboxMessageList.append(singleInbox)
            
        }
        if inboxMessageList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(inboxMessageList.count * 45)
        }
       tableInbox.hidden = false
        
    }
    
}


//MARK: Web Service Helper Method
extension InboxViewController{
    
    
    func getInbox(params: [String: AnyObject]){
        
        MBProgressHUD.showHUDAddedTo(self.tableInbox, animated: true)
        WebServiceHelper.getTeacherInbox(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDsForView(self?.tableInbox, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let inboxList = responseResult["inboxMessages"] as? [AnyObject]
                                if inboxList?.count > 0{
                                    self?.setInbox(inboxList!)
                                    self!.tableInbox.reloadData()
                                    
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
    
}







