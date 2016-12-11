//
//  NewMessageViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
//MARK: Textfield tag
let kGetParents = 0
let kDeadlineDate = 1
let kEventDate = 2
let kTime = 3
let kReminder = 4


class NewMessageViewController: UIViewController {

    //MARK: Normal Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var imgClubLogo: UIImageView!
    
    @IBOutlet weak var requireActionView: UIView!
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
    
    
    //MARK: TableView 
    
    @IBOutlet weak var lblSetReminder: UILabel!
    @IBOutlet weak var tableSetReminder: UITableView!
    
    var parentList = [Parent]()
    var teacherList = [Teacher]()
    var club_id: String = ""
    var class_id: String = ""
    var child_id: String = ""
    
    var isPickerShowing = false
    var pickerViewTag = -1
    var isRequiredActionTapped = false
    var isSetReminder = false
    var selectedParent = Parent()
    var selectedTeacher = Teacher()
    var currentTextField : UITextField?
    var isTeacher = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name": "child_name") as? String
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        if !isTeacher{
            requireActionView.alpha = 0
            child_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        }
        tableSendMessageTo.register(UINib(nibName: "AutoCompleteCell",bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        
        tableSetReminder.register(UINib(nibName: "AutoCompleteCell",bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        
        Helper.setTableViewDesign(tableSendMessageTo)
        Helper.setTableViewDesign(tableSetReminder)
        tableSendMessageTo.isHidden = true
        tableSetReminder.isHidden = true

        
        if Helper.getUserInfo()?.avatar_link != nil{
            Helper.loadImageFromUrl(url: (Helper.getUserInfo()?.avatar_link!)!, view: imgClubLogo)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewTrailingConstraint.constant = -UIScreen.main.bounds.size.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }

//MARK: BUTTON Action
extension NewMessageViewController{

    //MARK: Nav Bar button Action
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnSend(_ sender: UIButton) {
       
        validateField()
        
    }

    //MARK: Required Action Switch Control
    
    @IBAction func switchRequiredAction(_ sender: UISwitch) {
       
        if isTeacher{
            isRequiredActionTapped = sender.isOn ? true : false
            self.currentTextField?.resignFirstResponder()
            viewTrailingConstraint.constant = sender.isOn ? 0 : -Helper.getScreenWidth()
            let newPosition = CGPoint(x: Helper.getScreenWidth(),y: 0)
            scrollView.contentOffset = sender.isOn ? newPosition : scrollView.frame.origin
        }
   
    }
    @IBAction func btnSetReminderTapped(_ sender: UIButton) {
          self.currentTextField?.resignFirstResponder()
        if tableSetReminder.isHidden == false {
            tableSetReminder.isHidden = true
        }
        else{
        tableSetReminder.isHidden = false
      
        tableSetReminder.reloadData()
        }
    }
    
    @IBAction func switchSetReminder(_ sender: UISwitch) {
        if sender.isOn {
            isSetReminder = true
        }
        else{
            isSetReminder = false
        }
        
    }
    
    
    

    
    
    
    
    
    
    
    //MARK: Picker Control Button
    @IBAction func btnCancel(_ sender: UIButton) {
        showHidePicker()
    }
    
    
    
    @IBAction func btnDone(_ sender: UIButton) {
        let formatter = DateFormatter()
        switch pickerViewTag {
        case 1:
            formatter.dateFormat = "yyyy-MM-dd"
            
            txtDeadlineDate.text = formatter.string(from: pickerDate.date)
        
        case 2:
            formatter.dateFormat = "yyyy-MM-dd"
            txtEventDate.text = formatter.string(from: pickerDate.date)
        
        case 3:
            formatter.dateFormat = "hh:mm:ss a"
            txtTime.text = formatter.string(from: pickerDate.date)
        
        default:
            break
        }
        showHidePicker()
    }
    
    
    @IBAction func btnPickerSelectDate(_ sender: UIButton) {
        self.currentTextField?.resignFirstResponder()
        switch sender.tag{
            
        case kGetParents:
            var params = [String: AnyObject]()
            params["club_id"] = club_id as AnyObject?
            params["class_id"] = class_id as AnyObject?
            if isTeacher{
                getParents(params)
            }else{
                getTeachers(params)
            }
   
        case kDeadlineDate:
            if !isPickerShowing {
                self.pickerDate.datePickerMode = UIDatePickerMode.date
                showHidePicker()
                pickerViewTag = 1
            }
            
        case kEventDate:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.date
                showHidePicker()
                pickerViewTag = 2
                
            }
            
        case kTime:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.time
                showHidePicker()
                pickerViewTag = 3
            }
            
        case kReminder:
            if !isPickerShowing{
                self.pickerDate.datePickerMode = UIDatePickerMode.dateAndTime
                showHidePicker()
                pickerViewTag = 4
            }
            
        default:
            break
     
        
        }
        
    }
    
    
    
    
}

//MARK: SCROLL view Delegate
extension NewMessageViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.currentTextField?.resignFirstResponder()
        if isPickerShowing{
            showHidePicker()
        }
    }

}

//MARK: TextField Helper Method
extension NewMessageViewController: UITextFieldDelegate{

//    func didChangeText(textField: UITextField){
//        
//        switch textField.tag{
//        
//        case kSendMessage:
//            var params = [String: AnyObject]()
//            params["club_id"] = club_id
//            params["class_id"] = class_id
//            getParents(params)
//
//        
//
//        default:
//            break
//        
//        }
    
    
    
  //  }
    
//    func removeTable(){
//        tableSendMessageTo.hidden = true
//    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
        tableSetReminder.isHidden = true
       // showHidePicker()
    }
}



//MARK: TextView Delegate
extension NewMessageViewController: UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Details"{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Details"
        }
    }
}


//MARK: TableViewDelegate

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource
{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var rowCount: Int?
        switch tableView.tag{
        case 0:
            rowCount = isTeacher ? parentList.count : teacherList.count
        case 1:
          rowCount = 21
        default:
            break
        }
        return rowCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
        if tableView.tag == 0{
            if isTeacher{
            cell.lblPupil.text = parentList[indexPath.row].name
            }
            else{
               cell.lblPupil.text = teacherList[indexPath.row].name
            }
       
        }
            
        else {
        
         cell.lblPupil.text = String(indexPath.row + 1)
        
        }
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag{
        case 0:
            
            //1.select parent
            tableView.deselectRow(at: indexPath, animated: true)
            if isTeacher{
            selectedParent = parentList[indexPath.row]
            txtSendMessageTo.text = parentList[indexPath.row].name
            }
            else{
                selectedTeacher = teacherList[indexPath.row]
                txtSendMessageTo.text = teacherList[indexPath.row].name
            }
            tableSendMessageTo.isHidden = true
            
            //2.Update textField

        case 1:
            lblSetReminder.text = String(indexPath.row + 1)
            tableSetReminder.isHidden = true
            
        default:
            break
        
        }
        
    }

}


//MARK: View Controller Helper Method
extension NewMessageViewController{

    func setParents(_ data: [AnyObject]){
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
        tableSendMessageTo.isHidden = false
    }


    func setTeachers(_ data: [AnyObject]){
        teacherList.removeAll()
        for singleItem  in data {
            let item = singleItem as! [String: AnyObject]
            let singleTeacher = Teacher()
            singleTeacher.id = item["id"] as? Int
            singleTeacher.name = item["ucfirst(users.name)"] as? String
            singleTeacher.email = item["email"] as? String
    
            
            teacherList.append(singleTeacher)
            
        }
        
        tableHeight.constant = CGFloat (self.teacherList.count * 45)
        tableSendMessageTo.isHidden = false
        tableSendMessageTo.reloadData()
    }

    func showHidePicker(){
       // self.currentTextField?.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerBottomConstraint.constant = self.isPickerShowing ? -260.0 : 260.0
            self.view.layoutIfNeeded()
            }, completion: nil)
        isPickerShowing = !isPickerShowing
    }
    
    
    func validateField(){
        var params = [String: AnyObject]()
        params["club_id"] = club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?
        if !isTeacher {
           params["child_id"] = child_id as AnyObject?
        }
        var hasError = false
        var errorMessage = ""
        
        if Helper.isNotBlank(txtSendMessageTo.text!){
            if Helper.isSameText(txtSendMessageTo.text!, secondStr: isTeacher ? selectedParent.name!: selectedTeacher.name!){
                if isTeacher{
                    params["to"] = selectedParent.id! as AnyObject?
                }else{
                    params["to"] = selectedTeacher.id! as AnyObject?
                }
                
            
            if Helper.isNotBlank(txtMessageSubject.text!) {
                params["subject"] = txtMessageSubject.text! as AnyObject?
                
                if Helper.isNotBlank(txtViewMessageDetails.text) {
                    params["description"] = txtViewMessageDetails.text as AnyObject?
                    
                    if isRequiredActionTapped{
                        params["urgent_request"] = (isRequiredActionTapped ? "1" : "0") as AnyObject
                        if Helper.isNotBlank(txtDeadlineDate.text!){
                            params["deadline"] = txtDeadlineDate.text! as AnyObject?
                            
                            if Helper.isNotBlank(txtCost.text!) {
                                params["cost"] = txtCost.text! as AnyObject?
                                
                                if Helper.isNotBlank(txtEventDate.text!) {
                                    params["event_date"] = txtEventDate.text! as AnyObject?
                                    
                                    if Helper.isNotBlank(txtTime.text!) {
                                        params["event_time"] = txtTime.text! as AnyObject?
                                    
                                    
                                    if Helper.isNotBlank(txtPickUpPoint.text!) {
                                        params["pickup_point"] = txtPickUpPoint.text! as AnyObject?
                                        if !Helper.isSameText(lblSetReminder.text!, secondStr: "Set Reminder: 0 Days"){
                                            params["reminder"] = lblSetReminder.text! as AnyObject?
                                        }
                                        else{
                                            params["reminder"] = "0" as AnyObject?
                                        }
                                    }
                                    else{
                                        hasError = true
                                        errorMessage = "Please select pick up point."
                                    }
                                }
                                else{
                                    hasError = true
                                    errorMessage = "Please select event time."
                                
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
            errorMessage =  isTeacher ? "Please Select Parent From the List." : "Please Select Teacher From the List."
        }
        
       
        if hasError{
            self.showAlertOnMainThread(errorMessage)
        }
        
        sendMessage(params)
        
    }

}



//MARK: Web Service Helper Method
extension NewMessageViewController{

    func getParents(_ params: [String: AnyObject]){
    
        MBProgressHUD.showAdded(to: self.tableSendMessageTo, animated: true)
        WebServiceHelper.getParentList(params,url: kGetParentListUrl, onCompletion: {[weak self]
            response in
        MBProgressHUD.hideAllHUDs(for: self?.tableSendMessageTo, animated: true)
           
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let parentData = responseData as? [String: AnyObject] {
                            
                            let parentDataList = parentData["parents"] as? [AnyObject]
                            if (parentDataList?.count)! > 0{
                                
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
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:
                            "error") as! String)
                        
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

    
    func getTeachers(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.tableSendMessageTo, animated: true)
        WebServiceHelper.getParentList(params,url: kGetClassTeachersUrl, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.tableSendMessageTo, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let teacherData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = teacherData["response"] as? [String:AnyObject]{
                                let teacherArray = responseResult["teachers"] as? [AnyObject]
                                if (teacherArray?.count)! > 0{
                                    self?.setTeachers(teacherArray!)
                                    
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
                        }
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

    
    func sendMessage(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.saveMessage(params,url: isTeacher ? kSaveMessageToParentUrl: kSendMessageToTeacherUrl , onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                       self?.showAlertOnMainThread("Message Sent Successfully")
                            
                
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


}

