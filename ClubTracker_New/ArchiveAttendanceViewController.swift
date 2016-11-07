//
//  ArchiveAttendanceViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/23/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ArchiveAttendanceViewController: UIViewController {

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
        lblClassName.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        if childList.count > 0 {
//        club_Id = childList[0].club_id
//        class_id = childList[0].class_id
        club_id = (NSUserDefaults.standardUserDefaults().valueForKey("club_id") as? String)!
        class_id = (NSUserDefaults.standardUserDefaults().valueForKey("class_id") as? String)!
        updateVew()
            var params = [String : String]()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
           
            params["date"] = formatter.stringFromDate(NSDate())
            
            
            params["club_id"] = club_id!
            params["class_id"] = class_id!
            childList.removeAll()
            getChildAttendanceByDate(params, onCompletion: {
                success in
                self.tableAttendance.reloadData()
                
            })

        }
        tableAttendance.registerNib(UINib(nibName: "RegisterCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RegisterCell")
        Helper.setTableViewDesign(tableAttendance)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: Button Action 
extension ArchiveAttendanceViewController{
    ///Select Date
    @IBAction func btnSelectDate(sender: UIButton) {
        
        if !isPickerShowing{
           showHidePicker()
            
        }
    }

    
    
    //Cancel Button
    @IBAction func btnCancelTapped(sender: UIButton) {
        showHidePicker()
    }

    
    
    ///Done Button
    @IBAction func btnDoneTapped(sender: UIButton) {
            getAttendancebyDate()
     
    }
    
    
    
    
    ///Back Button
    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}


//MARK: View Controller Helper Method
extension ArchiveAttendanceViewController{
    func showHidePicker(){
       
        UIView.animateWithDuration(0.5, animations: {
            self.pickerConstraint.constant = self.isPickerShowing ? -260.0 : 60.0
            self.view.layoutIfNeeded()
            }, completion: nil)
             isPickerShowing = !isPickerShowing
    }

    
    
    //set child array
    func setChildsWithAttendance(data: [AnyObject]){
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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lblSelectedDate.text = formatter.stringFromDate(NSDate())
       
    }
    
    //get attendance by date
    func getAttendancebyDate(){
    
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lblSelectedDate.text = formatter.stringFromDate(pickerDate.date)
        showHidePicker()
    
        var params = [String : String]()
        params["date"] = lblSelectedDate.text!
        if childList.count > 0{
            params["club_id"] = club_id!
            params["class_id"] = class_id!
        }
      //  childList.removeAll()
        getChildAttendanceByDate(params, onCompletion: {
            success in
            self.tableAttendance.reloadData()
    
        })

    }

}

//MARK: TableView Delegate

extension ArchiveAttendanceViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let childItem = childList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("RegisterCell") as! RegisterCell
        cell.lblName.text = childItem.firstName! + " " + childItem.lastName!
        
        let status = Int(childItem.status!)!
        cell.setAttendanceStatus(status)
        
        return cell
    }
    
    
}


//MARK: Web Service Helper Method
extension ArchiveAttendanceViewController{

    //GET Child BY DATE
    func getChildAttendanceByDate(params: [String: String],onCompletion:(success: Bool)->()){
        
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
                            self!.setChildsWithAttendance(childDataList!)
                            onCompletion(success: true)
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                        
                    case 302:
                        self?.showAlertOnMainThread("No Result Found")
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    
                    case 404:
                        self?.showAlertOnMainThread("Attendance record not found")
                        self!.childList.removeAll()
                        self!.tableAttendance.reloadData()
                        
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

