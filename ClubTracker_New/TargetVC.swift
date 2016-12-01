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

       
        

        
        //MARK: Target TableView
        self.targetTableView.register(UINib(nibName: "TargetCell", bundle: Bundle.main), forCellReuseIdentifier: "TargetCell")
        setTableViewDesign(self.targetTableView)
        
        //MARK:Dropdown Pupil TableView
        self.searchPupilTableView.register(UINib(nibName: "AutoCompleteCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        
        setTableViewDesign(self.searchPupilTableView)
        
        
        ///Dropdown Table people List
        self.pupilList = ["Pupil-1","Pupil-2","Pupil-3","Pupil-4","Pupil-5"]
        
    }

    
    func setTableViewDesign(_ tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
        if tableView.tag == 0 {
            tableView.isHidden = true
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TargetVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let view = touch.view!
        if view.isDescendant(of: searchPupilTableView) {
            return false
        }
        return true
    }
    
}

//MARK: TextFieldDelegate
extension TargetVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtSearchPupil {
            searchPupilTableView.isHidden = false
             let subString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
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
                
                 searchPupilTableView.isHidden = true
            
            }
        }
        return true
    }

}


//MARK: Button Action
extension TargetVC{
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func btnSave(_ sender: UIButton) {
    }

    @IBAction func btnAddTargets(_ sender: UIButton) {
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
    
    @IBAction func btnSearchPeople(_ sender: UIButton) {
        
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
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return pupilList.count
        }else{
            return targetList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
            cell.lblPupil.text = pupilList[indexPath.row]
            return cell
        }else{
           let  cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell") as! TargetCell
             cell.targetLabel.text = targetList[indexPath.row]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            txtSearchPupil.text = pupilList[indexPath.row]
            searchPupilTableView.isHidden = true
            self.currentTxtField?.resignFirstResponder()
        }
    }
    

    


}


//MARK: Web Service Helper Method
extension TargetVC{

    
    

}



