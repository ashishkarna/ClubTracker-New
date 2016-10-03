//
//  TargetVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/13/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class TargetVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var formHolder: UIView!
    
    @IBOutlet weak var txtAddTarget: UITextField!
    @IBOutlet weak var txtSearchPupil: UITextField!
    
    @IBOutlet weak var searchPupilTableView: UITableView!
    @IBOutlet weak var tableHeightPupil: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var targetTableView: UITableView!
    
    @IBOutlet weak var lblTargetCompleted: UILabel!
    @IBOutlet weak var lblAttendance: UILabel!
    
    var currentTxtField: UITextField?
    var targetList = [String]()
    var pupilList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
       //setting up tap gesture
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        formHolder.addGestureRecognizer(tapGesture)
        
        //MARK: Target TableView
        self.targetTableView.registerNib(UINib(nibName: "TargetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TargetCell")
        setTableViewDesign(self.targetTableView)
        
        //MARK:Dropdown Pupil TableView
        self.searchPupilTableView.registerNib(UINib(nibName: "AutoCompleteCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AutoCompleteCell")
        
        setTableViewDesign(self.searchPupilTableView)
        
        
        ///Dropdown Table people List
        self.pupilList = ["Pupil-1","Pupil-2","Pupil-3","Pupil-4","Pupil-5"]
        
    }

    func viewTapped(recognizer: UITapGestureRecognizer){
    
        self.searchPupilTableView.hidden = true
        self.currentTxtField?.resignFirstResponder()
    }
    
    func setTableViewDesign(tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowOffset = CGSizeMake(0, 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
        if tableView.tag == 0 {
            tableView.hidden = true
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TargetVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let view = touch.view!
        if view.isDescendantOfView(searchPupilTableView) {
            return false
        }
        return true
    }
    
}

//MARK: TextFieldDelegate
extension TargetVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTxtField = textField
        
    }
    
     func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.currentTxtField?.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtSearchPupil {
            searchPupilTableView.hidden = false
             let subString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if !subString.isEmpty {
               
                //get Suggestion
                AutoComplete.sharedInstance.pupilName = self.pupilList
                let pupilNameSuggestion = AutoComplete.sharedInstance.pupilNameSuggestionFromPupilName(subString)
            
                //adjust height of dropdown tableview
                if pupilNameSuggestion.count < 3 {
                    tableHeightPupil.constant = CGFloat(pupilNameSuggestion.count * 45)
                }else{
                    tableHeightPupil.constant = CGFloat(3 * 45)
                }
                
                searchPupilTableView.reloadData()
                
            }else{
                
                 searchPupilTableView.hidden = true
            
            }
        }
        return true
    }

}


//MARK: Button Action
extension TargetVC{
    
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    @IBAction func btnSave(sender: UIButton) {
    }

    @IBAction func btnAddTargets(sender: UIButton) {
        self.currentTxtField?.resignFirstResponder()
        //new item add garda cell item add garne and reload table data
        
        let msg = validateTextField()
        
        if msg.isEmpty {
            targetList.append(txtAddTarget.text!)
            targetTableView.reloadData()
            txtAddTarget.text = ""
        }else{
        
            self.showAlertOnMainThread(msg)
        }
        
        
        
    }
    
    @IBAction func btnSearchPeople(sender: UIButton) {
        
        self.currentTxtField?.resignFirstResponder()
        let msg = validateTextField()
        
        if msg.isEmpty {
                targetTableView.reloadData()
            
        }else{
            
            self.showAlertOnMainThread(msg)
        }

    }
    
    
    //MARK: Validate TextField
    func validateTextField()->(String){
        if !Helper.isValidFullname(txtAddTarget.text!) {
            return ("Please enter the target")
        }
        
        if !Helper.isValidFullname(txtAddTarget.text!){
            return ("Please select the pupil")
        }
        return ""
    
    }
  
}


extension TargetVC : UITableViewDelegate{

    //MARK:Table View Deligates
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return pupilList.count
        }else{
            return targetList.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
           let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell") as! AutoCompleteCell
            cell.lblPupil.text = pupilList[indexPath.row]
            return cell
        }else{
           let  cell = tableView.dequeueReusableCellWithIdentifier("TargetCell") as! TargetCell
             cell.targetLabel.text = targetList[indexPath.row]
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 0 {
            txtSearchPupil.text = pupilList[indexPath.row]
            searchPupilTableView.hidden = true
            self.currentTxtField?.resignFirstResponder()
        }
    }
    

    


}