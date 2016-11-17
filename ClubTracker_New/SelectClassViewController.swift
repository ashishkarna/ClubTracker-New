//
//  SelectClassViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class SelectClassViewController: UIViewController {

    @IBOutlet weak var txtSelectClass: UITextField!
    
    @IBOutlet weak var tableSelectClass: UITableView!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    var tableViewDataSource = [String]()
    var classNameList = [String]()
    var classList = [Class]()
    var childList = [Child]()
    var childNameList = [String]()
    var stopEditing = false
    var selectedClass = Class()
    var isTeacher = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
      //  self.txtSelectClass.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:.EditingDidBegin)
        //self.txtSelectClass.addTarget(self, action: #selector(removeTable), forControlEvents:.EditingDidEnd)
        ///Tableview cell
        txtSelectClass.placeholder = isTeacher ? "Select Class" : "Select Child"
        tableSelectClass.register(UINib(nibName: "AutoCompleteCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        
        Helper.setTableViewDesign(tableSelectClass)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableSelectClass.isHidden = true
    }
    
    

 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }


//MARK: Button Action
extension SelectClassViewController{

    @IBAction func btnSelect(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            if tableSelectClass.isHidden == false{
                tableSelectClass.isHidden = true
            }
            else{
                if isTeacher{
                    getAllClass()
                }
                else{
                    getMyChildren()
                }
            }
            
        case 1:
            validateField()
            
        default:
            break
        }
        
       
        
        
    }

    func gotoMenu(){
    
        UserDefaults.standard.set(isTeacher ? true: false, forKey: "isTeacher")
        
        let mainTabBar = TabBarController()
        
        let homeVC = TeacherMenuViewController(nibName: "TeacherMenuViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.isNavigationBarHidden = true
        
        let helpVC = HelpVC(nibName: "HelpVC", bundle: nil)
        //let helpNav = UINavigationController(rootViewController: helpVC)
       // helpNav.navigationBar.hidden = true
        
        let faqVC = FAQVC(nibName: "FAQVC", bundle: nil)
        //let faqNav = UINavigationController(rootViewController: faqVC)
        
        let tutorialVC = TutorialViewController(nibName: "TutorialViewController", bundle: nil)
        
        let controllers = [homeNav,helpVC,faqVC,tutorialVC]
        mainTabBar.viewControllers = controllers
       //self.navigationController?.pushViewController(mainTabBar, animated: false)
        self.present(mainTabBar, animated: true, completion: nil)
    
    }
    
    func validateField(){
       var  hasError = false
        var errorMessage = ""
        if !Helper.isNotBlank(txtSelectClass.text!){
            hasError = true
            errorMessage = "Please enter class-name"
        
        }
        
        /// Error Exist
        if hasError{
            self.showAlertOnMainThread(errorMessage)
        }
        else{
            //goto menu
            gotoMenu()
        }
        
    
    }
 }



//MARK: TableViewDelegate
extension SelectClassViewController: UITableViewDelegate{

    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount:Int
        if isTeacher{
            rowCount = classNameList.count
        }
        else{
            rowCount = childNameList.count
        }
        
        return rowCount
        
        
          }
    
 
  
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
        if isTeacher{
            cell.lblPupil.text = classNameList[indexPath.row]
        }
        else{
            cell.lblPupil.text = childNameList[indexPath.row]
        }
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTeacher{
            txtSelectClass.text = classNameList[indexPath.row]
            for item in classList{
                if txtSelectClass.text == item.name{
                    let classId = String(item.id!)
                    let className = item.name!
                   
                    selectedClass = item
                   // let clubId = item.clubId!
                    UserDefaults.standard.setValue(classId, forKey: "class_id")
                    UserDefaults.standard.setValue(className, forKey: "class_name")
        
                    
                    //NSUserDefaults.standardUserDefaults().setValue(className, forKey: "club_id")
                    
                }
            }
        }
        else{
            txtSelectClass.text = childNameList[indexPath.row]
            let child_id = String(childList[indexPath.row].id!)
           let class_id = childList[indexPath.row].class_id!
            let club_id = childList[indexPath.row].club_id!
            let child_name = childList[indexPath.row].firstName!
            
            UserDefaults.standard.setValue(child_id, forKeyPath: "child_id")
            UserDefaults.standard.setValue(class_id, forKey: "class_id")
            UserDefaults.standard.setValue(club_id ,  forKey: "club_id")
            UserDefaults.standard.setValue(child_name, forKey: "child_name")
        
        }
        
        
            tableSelectClass.isHidden = true
        
    }



}


//MARK: Web Service Helper Method
extension SelectClassViewController{
    
    func getAllClass(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllClasses(nil, onCompletion: { [weak self]
            response in
           
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let classData = responseData as? [String: AnyObject] {
                            
                          let classDataList = classData["classes"] as? [AnyObject]
                            if (classDataList?.count)! > 0{
                                self!.setClasses(classDataList!)
                                self?.tableSelectClass.reloadData()
                            }
                            else{
                                self?.showAlertOnMainThread("Sorry! No Class Assigned.")
                               // self?.stopEditing = true
                               // self!.txtSelectClass.removeTarget(self, action: #selector(self!.didChangeText(_:)), forControlEvents:.EditingDidBegin)
                            
                            }
                          //  onCompletion(success: true)
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case .failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            })
        
}
    
    func getMyChildren(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getMyChildren(nil, onCompletion: { [weak self]
            response in
            
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let result = responseData as? [String: AnyObject] {
                            if let responseResult = result["response"] as? [String: AnyObject]{
                            let childs = responseResult["children"] as? [AnyObject]
                            if childs!.count > 0{
                                    self!.setChildrens(childs!)
                                    self!.tableSelectClass.reloadData()
                            }
                            
                            else{
                                self?.showAlertOnMainThread("No Result Found.")
                            }
                        }
                    }
                        
                            
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


//MARK: VIEW CONTROLLER Helper Method
extension SelectClassViewController{

    //set class array
    func setClasses(_ data: [AnyObject]){
        classNameList.removeAll()
        tableViewDataSource.removeAll()
        for item in data{
            let singleClass = Class()
            singleClass.id = item["id"] as? Int
            singleClass.name = item["name"] as? String
            singleClass.clubId = item["club_id"] as? String
            
            classList.append(singleClass)
            
            classNameList.append(singleClass.name!)
            
        }
        
        self.tableViewDataSource = classNameList
        if classNameList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(classNameList.count * 45)
        }
        tableSelectClass.isHidden = false

        
    }

    
    //SET CHILDREN
    
    func setChildrens(_ childs: [AnyObject]){
        childList.removeAll()
        childNameList.removeAll()
        tableViewDataSource.removeAll()
        
        for singleItem in childs{
            let item = singleItem as! [String:AnyObject]
            let singleChild = Child()
            singleChild.id = item["id"] as? Int
            singleChild.class_id = item["class_id"] as? String
            singleChild.club_id = item["club_id"] as? String
            singleChild.parent_id = item["parent_id"] as? String
            singleChild.firstName = item["first_name"] as? String
            singleChild.lastName = item["last_name"] as? String
            singleChild.class_name = item["class_name"] as? String
            
            childList.append(singleChild)
            childNameList.append(singleChild.firstName!)
            
        }
        
        if childList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(childList.count * 45)
        }
        tableSelectClass.isHidden = false
    }

}
