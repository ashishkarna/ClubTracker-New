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
        
        txtSearchItem.addTarget(self, action: #selector(didChangeText(_:)), for:UIControlEvents.editingChanged)
        
        //MARK: Target TableView
        self.faqTableView.register(UINib(nibName: "FAQCell", bundle: Bundle.main), forCellReuseIdentifier: "FAQCell")
        setTableViewDesign(self.faqTableView)
        
        //MARK:Dropdown Pupil TableView
        self.dropdownTableView.register(UINib(nibName: "AutoCompleteCell", bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        
        setTableViewDesign(self.dropdownTableView)
        
        
        ///Dropdown Table people List
        self.searchList = ["ques-1","ques-2","ques-3","ques-4","ques-5"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // (self.navigationController?.tabBarController as! TabBarController)
    }
    
    
    func didChangeText(_ textField: UITextField){
        dropdownTableView.isHidden = false
        
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
            
            dropdownTableView.isHidden = true
            
        }

    
    }
    func setTableViewDesign(_ tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
        if tableView.tag == 0 {
            tableView.isHidden = true
        }
    

}
}


//MARK: Button Action
extension FAQVC{

    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: TableView Delegate
    extension FAQVC : UITableViewDelegate{
        
        //MARK:Table View Deligates
        func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 0 {
                return self.searchList.count
            }else{
                return self.itemList.count
                
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 45
        }
        
        func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
            
            if tableView.tag == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
                cell.lblPupil.text = searchList[indexPath.row]
                return cell
            }else{
                let  cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as! FAQCell
                cell.itemCell.text = itemList[indexPath.row]
                return cell
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView.tag == 0 {
                txtSearchItem.text = searchList[indexPath.row]
                dropdownTableView.isHidden = true
              
            }
}

}
