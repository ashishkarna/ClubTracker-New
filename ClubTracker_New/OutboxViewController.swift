//
//  OutboxViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class OutboxViewController: UIViewController {

    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableOutbox: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var outboxMessageList = [Outbox]()
    var club_id = ""
    var class_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!
        tableOutbox.registerNib(UINib(nibName: "InboxMessageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "InboxCell")
        Helper.setTableViewDesign(tableOutbox)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableOutbox.hidden = true
        
        var params = [String: AnyObject]()
        params["club_id"] = club_id
        params["class_id"] = class_id
        getOutbox(params)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//Button Action

extension OutboxViewController{
    
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btnSearchTextTapped(sender: UIButton) {
        if Helper.isNotBlank(txtSearch.text!){
            var params = [String: AnyObject]()
            params["club_id"] = club_id
            params["class_id"] = class_id
            params["search_text"] = txtSearch.text!
            getOutbox(params)
        
        }
        
    }
    
    
}

//MARK: TableView Delegate
extension OutboxViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return outboxMessageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InboxCell") as! InboxMessageTableViewCell
        cell.lblTo.text = " To: "
        cell.lblDate.text = " Date: "
        cell.lblSubject.text = " Subject: "
        cell.lblTime.text = " Time: "
        if (outboxMessageList[indexPath.row].message_to) != nil{
            cell.lblTo.text =  cell.lblTo.text! + outboxMessageList[indexPath.row].message_to!
        }
        
        cell.lblDate.text = cell.lblDate.text! + Helper.getDate(outboxMessageList[indexPath.row].created_at!)
   
        if (outboxMessageList[indexPath.row].subject) != nil{
            cell.lblSubject.text = cell.lblSubject.text! + outboxMessageList[indexPath.row].subject!
        }
        
        cell.lblTime.text = cell.lblTime.text! + Helper.getTime(outboxMessageList[indexPath.row].created_at!)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Outbox"
        detailVC.outboxMessageDetail = outboxMessageList[indexPath.row]
        detailVC.isOutbox = true
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}


//MARK: View Controller Helper Method
extension OutboxViewController{
    func setOutbox(data: [AnyObject]){
        outboxMessageList.removeAll()
        for singleItem in data{
            
            let item = singleItem as! [String:AnyObject]
            let singleOutbox = Outbox()
            singleOutbox.identifier = item["identifier"] as? String
            singleOutbox.class_id = item["class_id"] as? String
            singleOutbox.club_id = item["club_id"] as? String
            singleOutbox.subject = item["subject"] as? String
            singleOutbox.message = item["message"] as? String
            singleOutbox.is_urgent = item["is_urgent"] as? String
            singleOutbox.deadline = item["deadline"] as? String
            singleOutbox.cost = item["cost"] as? String
            singleOutbox.event_date = item["event_date"] as? String
            singleOutbox.pickup_point = item["pickup_point"] as? String
            singleOutbox.reminder = item["reminder"] as? String
            singleOutbox.message_to = item["message_to"] as? String
            singleOutbox.created_at = item["created_at"] as? String
            
            outboxMessageList.append(singleOutbox)
        
        }
        if outboxMessageList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(outboxMessageList.count * 45)
        }
        tableOutbox.hidden = false
    
    }

}





//MARK: Web Service Helper Method
extension OutboxViewController{

    
    func getOutbox(params: [String: AnyObject]){
        
        MBProgressHUD.showHUDAddedTo(self.tableOutbox, animated: true)
        WebServiceHelper.getTeacherOutbox(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDsForView(self?.tableOutbox, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                        
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let outboxList = responseResult["outboxmessage"] as? [AnyObject]
                                if outboxList?.count > 0{
                                    self?.setOutbox(outboxList!)
                                    self!.tableOutbox.reloadData()
                                    
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

