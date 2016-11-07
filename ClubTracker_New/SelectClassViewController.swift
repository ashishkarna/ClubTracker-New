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
    var stopEditing = false
    var selectedClass = Class()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
        self.txtSelectClass.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:.EditingDidBegin)
        self.txtSelectClass.addTarget(self, action: #selector(removeTable), forControlEvents:.EditingDidEnd)
        ///Tableview cell
        
        tableSelectClass.registerNib(UINib(nibName: "AutoCompleteCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AutoCompleteCell")
        
        Helper.setTableViewDesign(tableSelectClass)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableSelectClass.hidden = true
    }
    
    
    
    func didChangeText(textField: UITextField){
        if !stopEditing{
            getAllClass()
        }

    }
    
    func removeTable(){
    
        tableSelectClass.hidden = true
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }


//MARK: Button Action
extension SelectClassViewController{

    @IBAction func btnSelect(sender: UIButton) {
        
        validateField()
       
        
        
    }

    func gotoMenu(){
    
        let mainTabBar = TabBarController()
        
        let homeVC = TeacherMenuViewController(nibName: "TeacherMenuViewController", bundle: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.navigationBarHidden = true
        
        let helpVC = HelpVC(nibName: "HelpVC", bundle: nil)
        //let helpNav = UINavigationController(rootViewController: helpVC)
       // helpNav.navigationBar.hidden = true
        
        let faqVC = FAQVC(nibName: "FAQVC", bundle: nil)
        //let faqNav = UINavigationController(rootViewController: faqVC)
        
        let tutorialVC = TutorialViewController(nibName: "TutorialViewController", bundle: nil)
        
        let controllers = [homeNav,helpVC,faqVC,tutorialVC]
        mainTabBar.viewControllers = controllers
       //self.navigationController?.pushViewController(mainTabBar, animated: false)
        self.presentViewController(mainTabBar, animated: true, completion: nil)
    
    }
    
    func validateField(){
       var  hasError = false
        var errorMessage = ""
        if Helper.isNotBlank(txtSelectClass.text!){
            if Helper.isSameText(txtSelectClass.text!, secondStr: selectedClass.name!){
                //proceed
            }
            else{
                hasError = true
                errorMessage = "Please select class from List"
            }
           
        }
        else{
            
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

    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return tableViewDataSource.count
          }
    
 
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell") as! AutoCompleteCell
            cell.lblPupil.text = tableViewDataSource[indexPath.row]
            return cell
      
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            txtSelectClass.text = tableViewDataSource[indexPath.row]
            for item in classList{
                if txtSelectClass.text == item.name{
                    let classId = String(item.id!)
                    let className = item.name!
                    selectedClass = item
                   // let clubId = item.clubId!
                    NSUserDefaults.standardUserDefaults().setValue(classId, forKey: "class_id")
                    NSUserDefaults.standardUserDefaults().setValue(className, forKey: "class_name")
                    
                    //NSUserDefaults.standardUserDefaults().setValue(className, forKey: "club_id")
                    
                }
            }
        
            tableSelectClass.hidden = true
        
    }



}


//MARK: Web Service Helper Method
extension SelectClassViewController{
    
    func getAllClass(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.getAllClasses(nil, onCompletion: { [weak self]
            response in
           
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let classData = responseData as? [String: AnyObject] {
                            
                          let classDataList = classData["classes"] as? [AnyObject]
                            if classDataList?.count > 0{
                                self!.setClasses(classDataList!)
                                self?.tableSelectClass.reloadData()
                            }
                            else{
                                self?.showAlertOnMainThread("Sorry! No Class Assigned.")
                                self?.stopEditing = true
                               // self!.txtSelectClass.removeTarget(self, action: #selector(self!.didChangeText(_:)), forControlEvents:.EditingDidBegin)
                            
                            }
                          //  onCompletion(success: true)
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
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
    
    //set class array
    func setClasses(data: [AnyObject]){
        classNameList.removeAll()
        tableViewDataSource.removeAll()
        for item in data{
            let singleClass = Class()
            singleClass.id = item["id"] as? Int
            singleClass.name = item["name"] as? String
            //singleClass.clubId = item["club_id"] as? String
            
            classList.append(singleClass)
            
            classNameList.append(singleClass.name!)

        }
        
        self.tableViewDataSource = classNameList
        
        self.tableHeight.constant = CGFloat(tableViewDataSource.count * 45)
        self.tableSelectClass.hidden = false
        
        
    
    }
}
