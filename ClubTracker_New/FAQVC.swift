//
//  FAQVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/17/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {

    @IBOutlet weak var dropdownTableView: UITableView!
    @IBOutlet weak var faqTableView: UITableView!
    
    @IBOutlet weak var txtSearchItem: UITextField!
    
    @IBOutlet weak var tableHeightSearch: NSLayoutConstraint!
    
    
    var searchList = [String]()
    var itemList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtSearchItem.addTarget(self, action: #selector(didChangeText(_:)), forControlEvents:UIControlEvents.EditingChanged)
        
        //MARK: Target TableView
        self.faqTableView.registerNib(UINib(nibName: "FAQCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "FAQCell")
        setTableViewDesign(self.faqTableView)
        
        //MARK:Dropdown Pupil TableView
        self.dropdownTableView.registerNib(UINib(nibName: "AutoCompleteCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AutoCompleteCell")
        
        setTableViewDesign(self.dropdownTableView)
        
        
        ///Dropdown Table people List
        self.searchList = ["ques-1","ques-2","ques-3","ques-4","ques-5"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // (self.navigationController?.tabBarController as! TabBarController)
    }
    
    
    func didChangeText(textField: UITextField){
        dropdownTableView.hidden = false
        
        if !textField.text!.isEmpty {
            
            //get Suggestion
            AutoComplete.sharedInstance.pupilName = self.searchList
            let pupilNameSuggestion = AutoComplete.sharedInstance.pupilNameSuggestionFromPupilName(textField.text!)
            
            //adjust height of dropdown tableview
            if pupilNameSuggestion.count < 3 {
                tableHeightSearch.constant = CGFloat(pupilNameSuggestion.count * 45)
            }else{
                tableHeightSearch.constant = CGFloat(3 * 45)
            }
            
            dropdownTableView.reloadData()
            
        }else{
            
            dropdownTableView.hidden = true
            
        }

    
    }
    func setTableViewDesign(tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowOffset = CGSizeMake(0, 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
        if tableView.tag == 0 {
            tableView.hidden = true
        }
    

}
}


//MARK: Button Action
extension FAQVC{

    @IBAction func btnBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

//MARK: TableView Delegate
    extension FAQVC : UITableViewDelegate{
        
        //MARK:Table View Deligates
        func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 0 {
                return self.searchList.count
            }else{
                return self.itemList.count
                
            }
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            return 45
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            if tableView.tag == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("AutoCompleteCell") as! AutoCompleteCell
                cell.lblPupil.text = searchList[indexPath.row]
                return cell
            }else{
                let  cell = tableView.dequeueReusableCellWithIdentifier("FAQCell") as! FAQCell
                cell.itemCell.text = itemList[indexPath.row]
                return cell
            }
            
            
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if tableView.tag == 0 {
                txtSearchItem.text = searchList[indexPath.row]
                dropdownTableView.hidden = true
              
            }
}

}
