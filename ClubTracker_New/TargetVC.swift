//
//  TargetVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/13/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

enum TableViewTag: Int{
    case pupil = 0
    case targets = 1
    case targetsOrPupil = 2
}

class TargetVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var formHolder: UIView!
    
    @IBOutlet weak var txtAddTarget: UITextField!
    @IBOutlet weak var txtSearchPupil: UITextField!
    @IBOutlet weak var txtSearchTarget: UITextField!
 
    
  
    
    @IBOutlet weak var searchPupilTableView: UITableView!
    
    @IBOutlet weak var searchTargetTableView: UITableView!
    
    @IBOutlet weak var tableHeightPupil: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var targetTableView: UITableView!
    
    @IBOutlet weak var lblTargetCompleted: UILabel!
    @IBOutlet weak var lblAttendance: UILabel!
    
    var currentTxtField: UITextField?
    var targetList = [Target]()
    var pupilList = [Child]()
    var selectedTarget = [Target]()
    var selectedPupil = [Pupil]()
    
    var isSelected = -1
    
    var selectedTargetItem = Target()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Target TableView
        self.targetTableView.register(UINib(nibName: "TargetCell", bundle: Bundle.main), forCellReuseIdentifier: "TargetCell")
        Helper.setTableViewDesign(self.targetTableView)
        
        //MARK:Dropdown Pupil TableView
        self.searchPupilTableView.register(UINib(nibName: "AutoCompleteCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
         Helper.setTableViewDesign(self.searchPupilTableView)
        
        //MARK: Dropdown Target TableView
        self.searchTargetTableView.register(UINib(nibName: "AutoCompleteCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        Helper.setTableViewDesign(self.searchTargetTableView)
       
        ///Dropdown Table people List
      //  self.pupilList = ["Pupil-1","Pupil-2","Pupil-3","Pupil-4","Pupil-5"]

        searchPupilTableView.isHidden = true
        searchTargetTableView.isHidden = true
        
        
        
        
    }

 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        if Helper.isNotBlank(txtAddTarget.text!){
        var params = [String: AnyObject]()
        params["club_id"] = Helper.getUserInfo()?.club_id as AnyObject
        params["class_id"] = UserDefaults.standard.value(forKey: "class_id") as AnyObject?
        params["start_date"] = "2016-10-10 20:00:00" as AnyObject?
        params["end_date"] = "2017-10-10 20:00:00" as AnyObject?
        params["title"] = txtAddTarget.text! as AnyObject?
        
            addTargets(params)
        }
        else{
            self.showAlertOnMainThread("Please enter the target.")
        }
        
    }
    
 
    
    
    @IBAction func selectPupilButtonTapped(_ sender: UIButton) {
        //show pupil dropdownList
        
       searchPupilTableView.isHidden = !searchPupilTableView.isHidden
        if !searchPupilTableView.isHidden{
            searchTargetTableView.isHidden = true
            getPupil()
           
        }
        
    }
    
    @IBAction func selectTargetButtonTapped(_ sender: UIButton) {
        //show target dropdownList
        searchTargetTableView.isHidden = !searchTargetTableView.isHidden
        if !searchTargetTableView.isHidden{
             searchPupilTableView.isHidden = true
             getTargets()
        }
        
    }
    
    
    @IBAction func btnSearchPeople(_ sender: UIButton) {
        //get target of selected pupil
        
        isSelected = 0
        if !Helper.isSameText(txtSearchPupil.text!, secondStr: "Select Pupil"){
            
            getTargetOfPupil()
        }
        
    }
    
    
    @IBAction func buttonSearchTargetTapped(_ sender: UIButton) {
        //get pupil of selected target
        isSelected = 1
        if !Helper.isSameText(txtSearchTarget.text!, secondStr: "Select Target"){
            
            getPupilOfTarget()
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
        switch tableView.tag {
        
        case TableViewTag.pupil.rawValue:
            return pupilList.count
        
        case TableViewTag.targets.rawValue:
            return targetList.count
        
        case TableViewTag.targetsOrPupil.rawValue:
            if isSelected > -1{
                return isSelected == 0 ? selectedPupil.count : selectedTarget.count
                }
            else{
                return 0
            }
        
        default:
            return 0 
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
            cell.lblPupil.text = pupilList[indexPath.row].firstName
            return cell
        }
            
        else if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
            cell.lblPupil.text = targetList[indexPath.row].title
            return cell
        }
            
        else{
            let  cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell") as! TargetCell
            cell.targetLabel.text = isSelected == 0 ? selectedPupil[indexPath.row].first_name : selectedTarget[indexPath.row].title
            return cell
          
        }
    }
        
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        
        case TableViewTag.pupil.rawValue:
            txtSearchPupil.text = pupilList[indexPath.row].firstName
            
            searchPupilTableView.isHidden = true
            
        
        case TableViewTag.targets.rawValue:
            txtSearchTarget.text = targetList[indexPath.row].title
            selectedTargetItem = targetList[indexPath.row]
            searchTargetTableView.isHidden = true
            
        case TableViewTag.targetsOrPupil.rawValue:
            //change status
            
            break
            
        default:
            break
        }
    
    }
    

    


}


//MARK: Web Service Helper Method
extension TargetVC{

    //add target
    func addTargets(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.addTarget(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                       self?.showAlertOnMainThread("Target added successfully.")
                       self?.txtAddTarget.text = ""
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

    //get target
    func getTargets(){
        var params = [String: AnyObject]()
        params["club_id"] = Helper.getUserInfo()?.club_id as AnyObject
        params["class_id"] = UserDefaults.standard.value(forKey: "class_id") as AnyObject?
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getTargets(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        let targetArray = (responseData as AnyObject).value(forKey:"targets") as! [AnyObject]
                        self?.setTarget(data: targetArray)
                        
                        self?.txtAddTarget.text = ""
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


    
    //get pupil
    func getPupil(){
        var params = [String: AnyObject]()
        params["class_id"] = UserDefaults.standard.value(forKey: "class_id") as AnyObject?
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllChilds(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        let pupilArray = (responseData as AnyObject).value(forKey:"childs") as! [AnyObject]
                        self?.setPupil(data: pupilArray)
                        
                        self?.txtAddTarget.text = ""
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

    
    
    
    //get pupil of target
    func getPupilOfTarget(){
        
        var params = [String: AnyObject]()
        
        params["club_id"] = Helper.getUserInfo()?.club_id as AnyObject
        params["class_id"] = UserDefaults.standard.value(forKey: "class_id") as AnyObject?
        params["target_id"] = selectedTargetItem.id! as AnyObject?
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getPupilOfTarget(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        let targetArray = (responseData as AnyObject).value(forKey:"pupils") as! [AnyObject]
                        self?.lblTargetCompleted.text = "Target Completed: " + ((responseData as AnyObject).value(forKey:"target_completes") as? String)!

                        self?.setTargetOfPupil(data: targetArray)
                        
                        self?.txtAddTarget.text = ""
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
    
    
    
    
    //get pupil of target
    func getTargetOfPupil(){
        
        var params = [String: AnyObject]()
        
        params["club_id"] = Helper.getUserInfo()?.club_id as AnyObject
        params["class_id"] = UserDefaults.standard.value(forKey: "class_id") as AnyObject?
        params["target_id"] = txtSearchTarget.text as AnyObject?
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getTargetOfPupil(params, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        let pupilArray = (responseData as AnyObject).value(forKey:"targets") as! [AnyObject]
                        self?.lblTargetCompleted.text = "Target Completed: " + ((responseData as AnyObject).value(forKey:"target_completes") as? String)!
                        self?.lblAttendance.text =  "Attendance: " + ((responseData as AnyObject).value(forKey:"attendances") as? String)!
                        self?.setPupilOfTarget(data: pupilArray)
                        
                        self?.txtAddTarget.text = ""
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



//MARK: VIEW Controller Helper Method
extension TargetVC{

    //set target list
    func setTarget(data:[AnyObject]){
        targetList.removeAll()
        for singleItem in data{
            let item = singleItem as! [String: AnyObject]
            let singleTarget = Target()
            singleTarget.id = item["id"] as? Int
            singleTarget.title = item["title"] as? String
            
            targetList.append(singleTarget)
        }
       
        searchTargetTableView.reloadData()
        
    }
    
    //set pupil list
    func setPupil(data:[AnyObject]){
        pupilList.removeAll()
        for singleItem in data{
            let item = singleItem as! [String: AnyObject]
            let singleChild = Child()
            singleChild.id = item["id"] as? Int
            singleChild.class_id = item["class_id"] as? String
            singleChild.club_id = item["club_id"] as? String
            singleChild.parent_id = item["parent_id"] as? String
            singleChild.firstName = item["first_name"] as? String
            singleChild.lastName = item["last_name"] as? String
            singleChild.class_name = item["class_name"] as? String
            
            
            
            pupilList.append(singleChild)
        }
        
        searchPupilTableView.reloadData()
        
    }
    
    //set targets of pupil
    func setTargetOfPupil(data:[AnyObject]){
        selectedTarget.removeAll()
        for singleItem in data{
            let item = singleItem as! [String: AnyObject]
            let singleTarget = Target()
            singleTarget.id = item["id"] as? Int
            singleTarget.title = item["title"] as? String
            singleTarget.status = item["status"] as? String
            
            selectedTarget.append(singleTarget)
        }
        
        targetTableView.reloadData()
        
    }
    
    //set pupil of target
    func setPupilOfTarget(data:[AnyObject]){
        selectedPupil.removeAll()
        for singleItem in data{
            let item = singleItem as! [String: AnyObject]
            let singlePupil = Pupil()
            singlePupil.child_id = item["child_id"] as? String
            singlePupil.status = item["status"] as? String
            singlePupil.first_name = item["first_name"] as? String
            singlePupil.last_name = item["last_name"] as? String
            singlePupil.title = item["title"] as? String
            singlePupil.child_id = item["child_id"] as? String
            
            selectedPupil.append(singlePupil)
        }
        
        targetTableView.reloadData()
        
    }
    
}

