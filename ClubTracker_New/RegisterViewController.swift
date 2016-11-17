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
    func tableViewDidselect(_ indexPath: IndexPath)
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
        lblClassName.text = UserDefaults.standard.value(forKey: "class_name") as? String
        
        tablePupil.register(UINib(nibName: "RegisterCell",bundle: Bundle.main), forCellReuseIdentifier: "RegisterCell")
        Helper.setTableViewDesign(tablePupil)
        
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        
        var params = [String: String]()
        params["club_id"] =  club_id
        params["class_id"] = class_id
        
        //setting todays date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.string(from: Date())
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
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        saveOrUpdateAttendance()
        
    }

    
    //If archive is switch on
    @IBAction func btnSwitchTapped(_ sender: UISwitch) {
     
        if childList.count > 0 {
            if sender.isOn{
                setAllPresent("1")
            }
            else{
                setAllPresent("-1")
            }
        }
        
        }
        
   
    @IBAction func btnArchiveTapped(_ sender: UIButton) {
        
        let archiveVC = ArchiveAttendanceViewController(nibName: "ArchiveAttendanceViewController",bundle: nil)
        archiveVC.childList = childList
        self.navigationController?.pushViewController(archiveVC, animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
   //in
    func buttonInTapped(_ sender: UIButton!) {
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
    func buttonAbsTapped(_ sender: UIButton!) {
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
    func buttonLateTapped(_ sender: UIButton!) {
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

extension RegisterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let childItem = childList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as! RegisterCell
        cell.lblName.text = childItem.firstName! + " " + childItem.lastName!
        
        cell.btnIn.tag = indexPath.row
        cell.btnAbs.tag = indexPath.row
        cell.btnLate.tag = indexPath.row
        
        cell.btnIn.addTarget(self, action: #selector(buttonInTapped), for: .touchUpInside)
        cell.btnAbs.addTarget(self, action: #selector(buttonAbsTapped), for: .touchUpInside)
        cell.btnLate.addTarget(self, action: #selector(buttonLateTapped), for: .touchUpInside)
       
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.string(from: Date())
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
        
        params["club_id"] =  club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?

        var attendanceDetails = [[String:Int]]()
        for item in self.childList{
            attendanceDetails.append(["child_id":item.id!,"status":Int(item.status!)!])
            
        }
        params["attendance_details"] = attendanceDetails as AnyObject?
        
        //setting todays date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["date"] = formatter.string(from: Date()) as AnyObject?
        print(params)

        self.updateChildAttendance(params, onCompletion: {
            
            success in
            self.showAlertOnMainThread("Attendance Updated")
            
        })

    }
    
    
    //save attendance
    func saveAttendance(){
        
        var params = [String: AnyObject]()
        params["club_id"] =  club_id as AnyObject?
        params["class_id"] = class_id as AnyObject?
        
        var attendanceDetails = [[String:Int]]()
        for item in self.childList{
            attendanceDetails.append(["child_id":item.id!,"status":Int(item.status!)!])
            
        }
        
        params["attendance_details"] = attendanceDetails as AnyObject?

        print(params)
        self.saveChildAttendance(params, onCompletion: {
            
            success in
            self.showAlertOnMainThread("Attendance Saved")
            
        })

    
    }
    
    //poulate all In
    func setAllPresent(_ status: String){
        //  if status == 1{
        for item in childList{
            item.status = status
        }
        // }
        tablePupil.reloadData()
        
    }
    
    
    //set child array with attendance
    func setChildsWithAttendance(_ data: [AnyObject]){
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
    func setChilds(_ data: [AnyObject]){
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
    func getAllChild(_ params: [String: String],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllChilds(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let childData = responseData as? [String: AnyObject] {
                            
                            let childDataList = childData["childs"] as? [AnyObject]
                            if (childDataList?.count)! > 0{
                                
                                self!.setChilds(childDataList!)
                                onCompletion(true)
                            }
                            else{
                                
                                self?.showAlertOnMainThread("No Result Found")
                            }
                            
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
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
    //Get Child Attendance
    func getChildAttendance(_ params: [String: String],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getChildAttendance(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            let childDataList = childData["attendances"] as? [AnyObject]
                        
                            if (childDataList?.count)! > 0{
                                
                                self!.isAttendanceTaken = true
                                self!.setChildsWithAttendance(childDataList!)
                                self!.tablePupil.reloadData()
                                onCompletion(true)
                            }
                            else{
                            
                                self?.showAlertOnMainThread("No Result Found")
                            }
                        
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 404:
                        
                        //self?.showAlertOnMainThread("Attendance Record Not Found")
                        onCompletion(false)
                        self!.isSaved = false
                    case 401: // Login Unsuccessful
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

    

    
    //Save Child
    func saveChildAttendance(_ params: [String: AnyObject],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.saveChild(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            
                            let childDataList = childData["attendances"] as? [AnyObject]
                            self!.setChildsWithAttendance(childDataList!)
                            self?.isSaved = true
                            onCompletion(true)
                        }
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 404:
                        self?.showAlertOnMainThread("Invalid data supplied")
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error ):
                let data = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print(data)
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
        })
        
    }
    
    
    
    
    //Update Child
    func updateChildAttendance(_ params: [String: AnyObject],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.updateChild(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    switch status_code {
                        
                    case 200 : //Successfully updated attendance
                        
                        if let childData = responseData as? [String: AnyObject] {
                            
                            let childDataList = childData["attendances"] as? [AnyObject]
                            self!.setChildsWithAttendance(childDataList!)
                            onCompletion(true)
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 302: //already taken
                        self?.showAlertOnMainThread("Validation Error")
                    case 404:
                        self?.showAlertOnMainThread("Invalid data supplied")
                    case 401: // Login Unsuccessful
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
