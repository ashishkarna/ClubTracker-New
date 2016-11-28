//
//  DiaryViewController.swift
//  ClubTracker
//
//  Created by Mohan on 11/24/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
import FSCalendar
class DiaryViewController: UIViewController {
    //MARK:- declaration
    var club_id: String = ""
    var class_id: String = ""
        var isTeacher = false
    var fullDiaryList = [DiaryModel]()
    var diaryListOnDate = [DiaryModel]()
     var urgentMessageDetail = UrgentRequest()
    //MARK:- OUTLets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    public let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    public let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
   // let datesWithCat = ["2015/05/05","2015/06/05","2015/07/05","2015/08/05","2015/09/05","2015/10/05","2015/11/05","2015/12/05","2016/01/06",
                        //"2016/02/06","2016/03/06","2016/04/06","2016/05/06","2016/06/06","2016/07/06"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          tableView.register(UINib(nibName: "DiaryListCell",bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
       // self.calendar.select(self.formatter.date(from: "2015/10/10")!)
        //        self.calendar.scope = .week
        let date = Date()
        self.lblTitleDate.text = "events list on date \(self.formatter.string(from: date))"

        tableView.isHidden = true
        self.calendar.scopeGesture.isEnabled = true
        
        club_id = (UserDefaults.standard.value(forKey: "club_id") as? String)!
        class_id = (UserDefaults.standard.value(forKey: "class_id") as? String)!
        var params = [String: String]()
        params["club_id"] =  club_id
        params["class_id"] = class_id
        getAllDairy(params, onCompletion:{
            success in
            
            if success{
                self.calendar.reloadData()
                let date = Date()
                self.lblTitleDate.text = "events list on date \(self.formatter.string(from: date))"
                self.diaryListOnDate.removeAll()
                for data in self.fullDiaryList{
                    if date == self.formatter.date(from: data.eventDate!){
                        self.diaryListOnDate += [data]
                    }
                }
                if self.diaryListOnDate.count <= 0{
                    self.tableView.isHidden = true
                }
                else{
                    self.tableView.isHidden = false
                }
                self.tableView.reloadData()
                
            }
            
        })

    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
}

extension DiaryViewController:FSCalendarDataSource, FSCalendarDelegate{


    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2010/01/01")!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2025/12/30")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
       // let day: Int! = self.gregorian.component(.day, from: date)
        var count = 0
        for data in fullDiaryList{
            if date == formatter.date(from: data.eventDate!){
               count += 1
            }
        }
        if count > 3{
            count = 3
        }
        return count;
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        NSLog("calendar did select date \(self.formatter.string(from: date))")
        lblTitleDate.text = "events list on date \(self.formatter.string(from: date))"
        diaryListOnDate.removeAll()
        for data in fullDiaryList{
            if date == formatter.date(from: data.eventDate!){
                diaryListOnDate += [data]
            }
        }
        if diaryListOnDate.count <= 0{
           tableView.isHidden = true
        }
        else{
            tableView.isHidden = false
        }
        tableView.reloadData()

    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        return [13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    //MARK:- Custom Functions
    func getAllDairy(_ params: [String: String],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllDiary(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let diaryList = responseData as? [String: AnyObject] {
                            
                            let diaryDataList = (diaryList["response"] as? [String: AnyObject])?["diary"] as? [AnyObject]
                            
                            if (diaryDataList?.count)! > 0{
                                
//                                self!.isAttendanceTaken = true
//                                self!.setChildsWithAttendance(childDataList!)
//                                self!.tablePupil.reloadData()
                                self?.fullDiaryList.removeAll()
                                for data in diaryDataList!{
                                    let myData = data as! [String: AnyObject];
                                    let dairy = DiaryModel()
                                    dairy.identifier = myData["identifier"] as! String?
                                    dairy.createdAt = myData["created_at"] as! String?
                                    dairy.eventDate = myData["event_date"] as! String?
                                    dairy.eventDescritpion = myData["event_descritpion"] as! String?
                                    dairy.eventTime = myData["event_time"] as? String
                                    dairy.eventTitle = myData["event_title"] as! String?
                                    dairy.pickPoint = myData["pick_point"] as! String?
                                    self?.fullDiaryList += [dairy]
                                }
                                onCompletion(true)
                            }
                            else{
                                
                               // self?.showAlertOnMainThread("No Result Found")
                            }

                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 301: break // Login Unsuccessful
                       // self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                        
                    case 500: break // Cannot Create Token
                       // self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
        })
        
    }
    func getAllDairyDetails(_ params: [String: String],onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllDiaryDetail(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let diaryList = responseData as? [String: AnyObject] {
                            
                            
                            if let responseResult = diaryList["response"] as? [String:AnyObject]{
                                let item = responseResult["message"] as! [String:AnyObject]
                               
                                let singleUrgent = UrgentRequest()
                                singleUrgent.identifier = item["identifier"] as? String
                                singleUrgent.class_id = item["class_id"] as? String
                                singleUrgent.club_id = item["club_id"] as? String
                                singleUrgent.subject = item["subject"] as? String
                                singleUrgent.message = item["message"] as? String
                                singleUrgent.is_urgent = item["is_urgent"] as? String
                                singleUrgent.deadline = item["deadline"] as? String
                                singleUrgent.cost = item["cost"] as? String
                                singleUrgent.event_date = item["event_date"] as? String
                                singleUrgent.event_time = item["event_time"] as? String
                                singleUrgent.pickup_point = item["pick_point"] as? String
                                singleUrgent.reminder = item["reminder"] as? String
                                singleUrgent.message_to = item["message_to"] as? String
                                singleUrgent.created_at = item["created_at"] as? String
                                singleUrgent.responded_percent = item["responded_percent"] as? Int
                                 self?.urgentMessageDetail = singleUrgent
                                onCompletion(true)
                            }
                            
                        }
                            
                        else{
                          //  self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 301: break // Login Unsuccessful
                       // self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
                        
                    case 500: break // Cannot Create Token
                       // self?.showAlertOnMainThread((responseData as AnyObject).value(forKey: "error") as! String)
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

extension DiaryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryListOnDate.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DiaryListCell
        cell.lblTitle?.text = diaryListOnDate[indexPath.row].eventTitle
        cell.eventTime.text = "event time : \(diaryListOnDate[indexPath.row].eventTime)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var params = [String: String]()
        params["club_id"] =  club_id
        params["class_id"] = class_id
        params["identifier"] = diaryListOnDate[indexPath.row].identifier
        
        getAllDairyDetails(params, onCompletion:{
            success in
            
            if success{
                let detailVC = UrgentMessageDetailViewController(nibName: "UrgentMessageDetailViewController", bundle: nil)
                detailVC.navTitle = "Urgent"
                detailVC.isTeacher = self.isTeacher
                 detailVC.urgentMessageDetail = self.urgentMessageDetail
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        })
     //   post /api/getTeacherRequestDetai
        
    }
}
