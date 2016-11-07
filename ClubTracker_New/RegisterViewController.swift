//
//  RegisterViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
import Alamofire

protocol tableListDelegates{
    func tableViewDidselect(indexPath: NSIndexPath)
}


class RegisterViewController: UIViewController {

    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var tablePupil: UITableView!
    @IBOutlet weak var btnAllPresent: UISwitch!
    @IBOutlet weak var btnArchive: UISwitch!
   
    var childList = [Child]()
    var tempChild = [Child]()
    
    var club_id: String = ""
    var class_id: String = ""
    var isAttendanceTaken = false
    
    var isSaved = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        
        tablePupil.registerNib(UINib(nibName: "RegisterCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RegisterCell")
        Helper.setTableViewDesign(tablePupil)
        
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!
        
        var params = [String: String]()
        params["club_id"] =  club_id
        params["class_id"] = class_id
        
        //setting todays date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.stringFromDate(NSDate())
        getChildAttendance(params, onCompletion:{
            success in
            
            if !success{
                self.getAllChild(params,onCompletion: {
                    success in
                    
                    self.tablePupil.reloadData()
                    
                })
            }
           
        })

        
       
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
}

//MARK: Button Action
extension RegisterViewController{
    
    
    
    
    //button save tapped
    
    @IBAction func btnSave(sender: UIButton) {
        
        saveOrUpdateAttendance()
        
    }

    
    //If archive is switch on
    @IBAction func btnSwitchTapped(sender: UISwitch) {
     
        if childList.count > 0 {
            if sender.on{
                setAllPresent("1")
            }
            else{
                setAllPresent("-1")
            }
        }
        
        }
        
   
    @IBAction func btnArchiveTapped(sender: UIButton) {
        
        let archiveVC = ArchiveAttendanceViewController(nibName: "ArchiveAttendanceViewController",bundle: nil)
        archiveVC.childList = childList
        self.navigationController?.pushViewController(archiveVC, animated: true)
    }
    
    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
   //in
    func buttonInTapped(sender: UIButton!) {
//        print("Button tapped in")
        if (childList[sender.tag].status != "1"){
            
            childList[sender.tag].status = "1"
        }
        else{
            
            childList[sender.tag].status = "-1"
        }
        tablePupil.reloadData()
    }
  
  //abs
    func buttonAbsTapped(sender: UIButton!) {
//        print("Button tapped abs")
        if childList[sender.tag].status != "0"{
            childList[sender.tag].status = "0"
        }
        else{
            childList[sender.tag].status = "-1"
        }
        tablePupil.reloadData()
   }
    
    //late
    func buttonLateTapped(sender: UIButton!) {
        print("Button tapped late")
        if childList[sender.tag].status != "2"{
            childList[sender.tag].status = "2"
        }
        else{
            childList[sender.tag].status = "-1"
        }
        tablePupil.reloadData()
    }

}





//MARK: TableView Delegate

extension RegisterViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let childItem = childList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("RegisterCell") as! RegisterCell
        cell.lblName.text = childItem.firstName! + " " + childItem.lastName!
        
        cell.btnIn.tag = indexPath.row
        cell.btnAbs.tag = indexPath.row
        cell.btnLate.tag = indexPath.row
        
        cell.btnIn.addTarget(self, action: #selector(buttonInTapped), forControlEvents: .TouchUpInside)
        cell.btnAbs.addTarget(self, action: #selector(buttonAbsTapped), forControlEvents: .TouchUpInside)
        cell.btnLate.addTarget(self, action: #selector(buttonLateTapped), forControlEvents: .TouchUpInside)
       
        let status = Int(childItem.status!)!
        cell.setAttendanceStatus(status)
        
        return cell
    }
    
 
}


//MARK: Helper Method for View Controller
extension RegisterViewController{

    //save or update attendance
    func saveOrUpdateAttendance(){
    var params = [String: String]()

     
        params["club_id"] =  club_id
        params["class_id"] = class_id
        
        //setting todays date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.stringFromDate(NSDate())
        if (childList.count > 0){
        if isAttendanceTaken{
             self.updateAttendance() // update Attendance
        }
        else{
            self.saveAttendance() // save attendance
        }
        }
        else{
            self.showAlertOnMainThread("Cannot Saved Empty Sets")
        }

    }
  
    
    
    //update Attendance
    func updateAttendance(){
        var params = [String: AnyObject]()
        
        params["club_id"] =  club_id
        params["class_id"] = class_id

        var attendanceDetails = [[String:Int]]()
        for item in self.childList{
            attendanceDetails.append(["child_id":item.id!,"status":Int(item.status!)!])
            
        }
        params["attendance_details"] = attendanceDetails
        
        //setting todays date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.stringFromDate(NSDate())
        print(params)

        self.updateChildAttendance(params, onCompletion: {
            
            success in
            self.showAlertOnMainThread("Attendance Updated")
            
        })

    }
    
    
    //save attendance
    func saveAttendance(){
        
        var params = [String: AnyObject]()
        params["club_id"] =  club_id
        params["class_id"] = class_id
        
        var attendanceDetails = [[String:Int]]()
        for item in self.childList{
            attendanceDetails.append(["child_id":item.id!,"status":Int(item.status!)!])
            
        }
        
        params["attendance_details"] = attendanceDetails

        print(params)
        self.saveChildAttendance(params, onCompletion: {
            
            success in
            self.showAlertOnMainThread("Attendance Saved")
            
        })

    
    }
    
    //poulate all In
    func setAllPresent(status: String){
        //  if status == 1{
        for item in childList{
            item.status = status
        }
        // }
        tablePupil.reloadData()
        
    }
    
    
    //set child array with attendance
    func setChildsWithAttendance(data: [AnyObject]){
        childList.removeAll()
        for item in data{
            let singleChild = Child()
            singleChild.id = Int(item["child_id"] as! String)
            singleChild.firstName = item["first_name"] as? String
            singleChild.lastName = item["last_name"] as? String
            singleChild.status = item["status"] as? String
            
            childList.append(singleChild)
            
        }
        
    }

    //set child array
    func setChilds(data: [AnyObject]){
        childList.removeAll()
        for item in data{
            let singleChild = Child()
            singleChild.id = item["id"] as? Int
            singleChild.firstName = item["first_name"] as? String
            singleChild.lastName = item["last_name"] as? String
            singleChild.status = item["status"] as? String

            childList.append(singleChild)
            
        }
        
    }

    

}


//MARK: Web Service Helper Method
extension RegisterViewController{
    
    
    ///Get All Child
    func getAllChild(params: [String: String],onCompletion:(success: Bool)->()){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.getAllChilds(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let childData = responseData as? [String: AnyObject] {
                        
                            let childDataList = childData["childs"] as? [AnyObject]
                            if childDataList?.count > 0{
                                
                                self!.setChilds(childDataList!)
                                onCompletion(success: true)
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
    
    //Get Child Attendance
    func getChildAttendance(params: [String: String],onCompletion:(success: Bool)->()){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.getChildAttendance(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            let childDataList = childData["attendances"] as? [AnyObject]
                        
                            if childDataList?.count > 0{
                                
                                self!.isAttendanceTaken = true
                                self!.setChildsWithAttendance(childDataList!)
                                self!.tablePupil.reloadData()
                                onCompletion(success: true)
                            }
                            else{
                            
                                self?.showAlertOnMainThread("No Result Found")
                            }
                        
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 404:
                        
                        //self?.showAlertOnMainThread("Attendance Record Not Found")
                        onCompletion(success: false)
                        self!.isSaved = false
                    case 401: // Login Unsuccessful
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

    

    
    //Save Child
    func saveChildAttendance(params: [String: AnyObject],onCompletion:(success: Bool)->()){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.saveChild(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            
                            let childDataList = childData["attendances"] as? [AnyObject]
                            self!.setChildsWithAttendance(childDataList!)
                            self?.isSaved = true
                            onCompletion(success: true)
                        }
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 404:
                        self?.showAlertOnMainThread("Invalid data supplied")
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.Failure(let error ):
                let data = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                print(data)
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            })
        
    }

    
    
    
    //Update Child
    func updateChildAttendance(params: [String: AnyObject],onCompletion:(success: Bool)->()){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.updateChild(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    switch status_code {
                        
                    case 200 : //Successfully updated attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            
                            let childDataList = childData["attendances"] as? [AnyObject]
                            self!.setChildsWithAttendance(childDataList!)
                            onCompletion(success: true)
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 302: //already taken
                        self?.showAlertOnMainThread("Validation Error")
                    case 404:
                        self?.showAlertOnMainThread("Invalid data supplied")
                    case 401: // Login Unsuccessful
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

