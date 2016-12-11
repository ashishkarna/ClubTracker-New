//
//  ArchiveAttendanceViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/23/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ArchiveAttendanceViewController: UIViewController {

    
    
    @IBOutlet weak var imgClubLogo: UIImageView!
    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var tableAttendance: UITableView!
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    @IBOutlet weak var pickerConstraint: NSLayoutConstraint!
    
    
    
    var isPickerShowing = false
    var childList = [Child]()
    var club_id: String?
    var class_id: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = UserDefaults.standard.value(forKey: "class_name") as? String
        if childList.count > 0 {
//        club_Id = childList[0].club_id
//        class_id = childList[0].class_id
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        updateVew()
            var params = [String : String]()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
           
            params["date"] = formatter.string(from: Date())
            
            
            params["club_id"] = club_id!
            params["class_id"] = class_id!
            childList.removeAll()
            getChildAttendanceByDate(params, onCompletion: {
                success in
                self.tableAttendance.reloadData()
                
            })

        }
        tableAttendance.register(UINib(nibName: "RegisterCell",bundle: Bundle.main), forCellReuseIdentifier: "RegisterCell")
        Helper.setTableViewDesign(tableAttendance)
        
        if Helper.getUserInfo()?.avatar_link != nil{
            Helper.loadImageFromUrl(url: (Helper.getUserInfo()?.avatar_link!)!, view: imgClubLogo)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: Button Action 
extension ArchiveAttendanceViewController{
    ///Select Date
    @IBAction func btnSelectDate(_ sender: UIButton) {
        
        if !isPickerShowing{
           showHidePicker()
            
        }
    }

    
    
    //Cancel Button
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        showHidePicker()
    }

    
    
    ///Done Button
    @IBAction func btnDoneTapped(_ sender: UIButton) {
            getAttendancebyDate()
     
    }
    
    
    
    
    ///Back Button
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: View Controller Helper Method
extension ArchiveAttendanceViewController{
    func showHidePicker(){
       
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerConstraint.constant = self.isPickerShowing ? -260.0 : 60.0
            self.view.layoutIfNeeded()
            }, completion: nil)
             isPickerShowing = !isPickerShowing
    }

    
    
    //set child array
    func setChildsWithAttendance(_ data: [AnyObject]){
        childList.removeAll()
        for item in data{
            let singleChild = Child()
            singleChild.id = Int(item["child_id"] as! String)
            singleChild.firstName = item["first_name"] as? String
            singleChild.lastName = item["last_name"] as? String
            singleChild.status = item["status"] as? String
            // singleChild.club_id = item["club_id"] as? String
            // singleChild.class_id = item["class_id"] as? String
            
            
            childList.append(singleChild)
            
        }
        
    }


    
  //getChildAttendance Date
    func updateVew(){

        //setting todays date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lblSelectedDate.text = formatter.string(from: Date())
       
    }
    
    //get attendance by date
    func getAttendancebyDate(){
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lblSelectedDate.text = formatter.string(from: pickerDate.date)
        showHidePicker()
    
        var params = [String : String]()
        params["date"] = lblSelectedDate.text!
        //if childList.count > 0{
            params["club_id"] = club_id!
            params["class_id"] = class_id!
        //}
        childList.removeAll()
        getChildAttendanceByDate(params, onCompletion: {
            success in
            self.tableAttendance.reloadData()
    
        })

    }

}

//MARK: TableView Delegate

extension ArchiveAttendanceViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let childItem = childList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as! RegisterCell
        cell.lblName.text = childItem.firstName! + " " + childItem.lastName!
        
        let status = Int(childItem.status!)!
        cell.setAttendanceStatus(status)
        
        return cell
    }
    
    
}


//MARK: Web Service Helper Method
extension ArchiveAttendanceViewController{

    //GET Child BY DATE
    func getChildAttendanceByDate(_ params: [String: String],onCompletion:@escaping (_ success: Bool)->()){
        
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
                            self!.setChildsWithAttendance(childDataList!)
                            onCompletion(true)
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                        
                    case 302:
                        self?.showAlertOnMainThread("No Result Found")
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                    
                    case 404:
                        self?.showAlertOnMainThread("Attendance record not found")
                        self!.childList.removeAll()
                        self!.tableAttendance.reloadData()
                        
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

