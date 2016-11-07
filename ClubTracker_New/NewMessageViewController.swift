//
//  NewMessageViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
//MARK: Textfield tag
let kSendMessage = 0
let kDeadlineDate = 1
let kEventDate = 2
let kTime = 3
let kReminder = 4


class NewMessageViewController: UIViewController {

    //MARK: Normal Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var txtSendMessageTo: UITextField!
    @IBOutlet weak var txtMessageSubject: UITextField!
    @IBOutlet weak var txtViewMessageDetails: UITextView!
    @IBOutlet weak var tableSendMessageTo: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!

    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    
    
    
    //MARK: Required Action Outlet
    
    @IBOutlet weak var txtDeadlineDate: UITextField!
    @IBOutlet weak var txtCost: UITextField!
    @IBOutlet weak var txtEventDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtPickUpPoint: UITextField!


//MARK: Picker Outlet
    
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var pickerBottomConstraint: NSLayoutConstraint!
    
    
    var parentList = [Parent]()
    var club_id: String = ""
    var class_id: String = ""
    
    var isPickerShowing = false
    var pickerViewTag = -1
    var isRequiredActionTapped = false
    var isSetReminder = false
    var selectedParent = Parent()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!
        
        
        tableSendMessageTo.registerNib(UINib(nibName: "AutoCompleteCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AutoCompleteCell")
        
        Helper.setTableViewDesign(tableSendMessageTo)
        tableSendMessageTo.hidden = true
        
        txtSendMessageTo.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents: .EditingDidBegin)
        
        txtSendMessageTo.addTarget(self, action: #selector(removeTable), forControlEvents: .EditingDidEnd)
        txtDeadlineDate.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:.EditingDidBegin)
        txtEventDate.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:.EditingDidBegin)
        txtTime.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:.EditingDidBegin)
       
        
    }
    override func viewWillAppear(animated: Bool) {
        viewTrailingConstraint.constant = -UIScreen.mainScreen().bounds.size.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }

//MARK: BUTTON Action
extension NewMessageViewController{

    //MARK: Nav Bar button Action
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    @IBAction func btnSend(sender: UIButton) {
       
        validateField()
        
    }

    //MARK: Required Action Switch Control
    
    @IBAction func switchRequiredAction(sender: UISwitch) {
       
        isRequiredActionTapped = sender.on ? true : false
        
        viewTrailingConstraint.constant = sender.on ? 0 : -UIScreen.mainScreen().bounds.size.width
   
    }
    
    @IBAction func switchSetReminder(sender: UISwitch) {
        if sender.on {
            isSetReminder = true
        }
        else{
            isSetReminder = false
        }
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: Picker Control Button
    @IBAction func btnCancel(sender: UIButton) {
        showHidePicker()
    }
    
    
    
    @IBAction func btnDone(sender: UIButton) {
        let formatter = NSDateFormatter()
        switch pickerViewTag {
        case 1:
            formatter.dateFormat = "yyyy-MM-dd"
            
            txtDeadlineDate.text = formatter.stringFromDate(pickerDate.date)
        
        case 2:
            formatter.dateFormat = "yyyy-MM-dd"
            txtEventDate.text = formatter.stringFromDate(pickerDate.date)
        
        case 3:
            formatter.dateFormat = "hh:mm:ss a"
            txtTime.text = formatter.stringFromDate(pickerDate.date)
        
        default:
            break
        }
        showHidePicker()
    }
    
    
    
}

//MARK: TextField Helper Method
extension NewMessageViewController{

    func didChangeText(textField: UITextField){
        
        switch textField.tag{
        
        case kSendMessage:
            var params = [String: AnyObject]()
            params["club_id"] = club_id
            params["class_id"] = class_id
            getParents(params)

        
        case kDeadlineDate:
            if !isPickerShowing {
                self.pickerDate.datePickerMode = UIDatePickerMode.Date
                showHidePicker()
                pickerViewTag = 1
            }
            
        case kEventDate:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.Date
                showHidePicker()
                pickerViewTag = 2
                
            }
            
        case kTime:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.Time
                showHidePicker()
                pickerViewTag = 3
            }
            
        case kReminder:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.DateAndTime
                showHidePicker()
                pickerViewTag = 4
            }
            
        default:
            break
        
        }
        
    
    
    }
    
    func removeTable(){
        tableSendMessageTo.hidden = true
    }

}

//MARK: TableViewDelegate

extension NewMessageViewController: UITableViewDelegate{

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return parentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell") as! AutoCompleteCell
        cell.lblPupil.text = parentList[indexPath.row].name
        
        return cell
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      //1.select parent
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedParent = parentList[indexPath.row]
        txtSendMessageTo.text = parentList[indexPath.row].name
        tableSendMessageTo.hidden = true
        
        //2.Update textField
        
    }

}


//MARK: View Controller Helper Method
extension NewMessageViewController{

    func setParents(data: [AnyObject]){
        parentList.removeAll()
        for item  in data {
            let singleParent = Parent()
            singleParent.id = item["id"] as? Int
            singleParent.name = item["name"] as? String
            singleParent.email = item["email"] as? String
            singleParent.firstName = item["firstName"] as? String
            singleParent.lastName = item["lastName"] as? String
            singleParent.avatar = item["avatar"] as? String
            singleParent.avatarLink = item["avatarLink"] as? String
            
            parentList.append(singleParent)
        
        }
        
        tableHeight.constant = CGFloat (self.parentList.count * 45)
        tableSendMessageTo.hidden = false
    }


    
    func showHidePicker(){
        
        UIView.animateWithDuration(0.5, animations: {
            self.pickerBottomConstraint.constant = self.isPickerShowing ? -260.0 : 60.0
            self.view.layoutIfNeeded()
            }, completion: nil)
        isPickerShowing = !isPickerShowing
    }
    
    
    func validateField(){
        var params = [String: AnyObject]()
        params["club_id"] = club_id
        params["class_id"] = class_id
        
        var hasError = false
        var errorMessage = ""
        
        if Helper.isNotBlank(txtSendMessageTo.text!){
            if Helper.isSameText(txtSendMessageTo.text!, secondStr: selectedParent.name!){
            params["to"] = selectedParent.id!
                
            
            if Helper.isNotBlank(txtMessageSubject.text!) {
                params["subject"] = txtMessageSubject.text!
                
                if Helper.isNotBlank(txtViewMessageDetails.text) {
                    params["description"] = txtViewMessageDetails.text
                    
                    if isRequiredActionTapped{
                        params["urgent_request"] = isRequiredActionTapped ? "1":"0"
                        
                        if Helper.isNotBlank(txtDeadlineDate.text!){
                            params["deadline"] = txtDeadlineDate.text!
                            
                            if Helper.isNotBlank(txtCost.text!) {
                                params["cost"] = txtCost.text!
                                
                                if Helper.isNotBlank(txtEventDate.text!) {
                                    params["event_date"] = txtEventDate.text!
                                    
                                    if Helper.isNotBlank(txtPickUpPoint.text!) {
                                        params["pickup_point"] = txtPickUpPoint.text!
                                        
                                        params["reminder"] = isSetReminder ? 1 : 0
                                    }
                                    else{
                                        hasError = true
                                        errorMessage = "Please select pick up point."
                                    }
                                }
                                else{
                                    hasError = true
                                    errorMessage = "Please select Event Date."
                                }
                            }
                            else{
                                hasError = true
                                errorMessage = "Please enter cost."
                            }
                        }
                        else{
                            hasError = true
                            errorMessage = "Please Select DeadLine Date."
                        }
                        
                    }
                }
                else{
                    hasError = true
                    errorMessage = "Please enter message details."
                }
                
            }
            else{
                hasError = true
                errorMessage = "Please enter the subject."
            }
            
            
        }
            else{
                hasError = true
                errorMessage = "Please Select Parent From the List."
            }
        }
        else{
            hasError = true
            errorMessage = "Please Select Parent From the List."
        }
        
       
        if hasError{
            self.showAlertOnMainThread(errorMessage)
        }
        
        sendMessage(params)
        
    }

}



//MARK: Web Service Helper Method
extension NewMessageViewController{

    func getParents(params: [String: AnyObject]){
    
        MBProgressHUD.showHUDAddedTo(self.tableSendMessageTo, animated: true)
        WebServiceHelper.getParentList(params, onCompletion: {[weak self]
            response in
        MBProgressHUD.hideAllHUDsForView(self?.tableSendMessageTo, animated: true)
           
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let parentData = responseData as? [String: AnyObject] {
                            
                            let parentDataList = parentData["parents"] as? [AnyObject]
                            if parentDataList?.count > 0{
                                
                                self!.setParents(parentDataList!)
                                self?.tableSendMessageTo.reloadData()
                            }
                            else{
                                
                                self?.showAlertOnMainThread("No Result Found")
                            }
                            
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
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

    
    func sendMessage(params: [String: AnyObject]){
        
        MBProgressHUD.showHUDAddedTo(self.tableSendMessageTo, animated: true)
        WebServiceHelper.saveMessage(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDsForView(self?.tableSendMessageTo, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                       self?.showAlertOnMainThread("Message Sent Successfully")
                            
                
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

