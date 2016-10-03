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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///Show Dropdown
        txtSelectClass.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:UIControlEvents.EditingChanged)
        
        ///Tableview cell
        tableSelectClass.registerNib(UINib(nibName: "AutoCompleteCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AutoCompleteCell")
    
        Helper.setTableViewDesign(tableSelectClass)
        
        
        
        tableViewDataSource = ["class-0","class-1","class-3","class-4","class-5","class-6","class-7","class-8","class-9"]
    }
    
    
    func didChangeText(textField: UITextField){
        tableSelectClass.hidden = false
        
        if !textField.text!.isEmpty {
            
            //get Suggestion
            AutoComplete.sharedInstance.pupilName = self.tableViewDataSource
            let classNameSuggestion = AutoComplete.sharedInstance.pupilNameSuggestionFromPupilName(textField.text!)
            
            //adjust height of dropdown tableview
            if classNameSuggestion.count < 6 {
                tableHeight.constant = CGFloat(classNameSuggestion.count * 44)
            }else{
                tableHeight.constant = CGFloat(6 * 44)
            }
            
            tableSelectClass.reloadData()
            
        }else{
            
           tableSelectClass.hidden = true
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let controllers = [homeNav,helpVC,faqVC]
        mainTabBar.viewControllers = controllers
        self.navigationController?.pushViewController(mainTabBar, animated: false)
    
    }
    
    func validateField(){
       var  hasError = false
        var errorMessage = ""
        if Helper.isNotBlank(txtSelectClass.text!){
            if Helper.isContainsInStreetList(txtSelectClass.text!){
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
           tableSelectClass.hidden = true
        
    }



}
