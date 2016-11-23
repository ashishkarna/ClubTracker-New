//
//  CreateChatViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/23/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class CreateChatViewController: UIViewController {

    @IBOutlet weak var lblClassName: UILabel!
    
    @IBOutlet weak var lblChatMember: UILabel!
    
    @IBOutlet weak var textChatName: UITextField!
    
    @IBOutlet weak var textViewOpeningMessage: UITextView!
    
    
    @IBOutlet weak var tableMember: UITableView!
    
    var isTeacher = false
    
    
    var chatMemberList = [ChatMember]()
    var selectedMember = ChatMember()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name": "child_name") as? String
         tableMember.register(UINib(nibName: "AutoCompleteCell",bundle: Bundle.main), forCellReuseIdentifier: "AutoCompleteCell")
        Helper.setTableViewDesign(tableMember)
        tableMember.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Button Action Method

extension CreateChatViewController{

    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSelectMemberPressed(_ sender: UIButton) {
        //select member
        tableMember.isHidden = !tableMember.isHidden
        if !tableMember.isHidden{
            getPossibleChatMember()
        }
        
    }

}



//MARK: TableView Delegate Method

extension CreateChatViewController: UITableViewDelegate, UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return chatMemberList.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell") as! AutoCompleteCell
        cell.lblPupil.text = chatMemberList[indexPath.row].name
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMember = chatMemberList[indexPath.row]
        textChatName.text = selectedMember.name
        tableMember.isHidden = true
            
    }
    
}



//MARK: View Controller Helper Method
extension CreateChatViewController{
    func setMemebers(data:[Any]){
        chatMemberList.removeAll()
        for singleItem  in data {
            let item = singleItem as! [String: AnyObject]
            let singleMember = ChatMember()
            singleMember.id = item["id"] as? String
            singleMember.name = item["name"] as? String
           // singleMember.email = item["email"] as? String
            
            
            chatMemberList.append(singleMember)
            
        }

        tableMember.isHidden = false
        tableMember.reloadData()

    }



}




//MARK: Web Service Helper Method
extension CreateChatViewController{
    func getPossibleChatMember(){
        
        MBProgressHUD.showAdded(to: self.tableMember, animated: true)
        WebServiceHelper.getParentList(nil,url: kgetListOfPossibleChatMembersUrl, onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.tableMember, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let teacherData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = teacherData["response"] as? [String:AnyObject]{
                                let memberArray = responseResult["potentialMembers"] as? [AnyObject]
                                if (memberArray?.count)! > 0{
                                    self?.setMemebers(data: memberArray!)
                                    
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
                        }
                    case 301: // Login Unsuccessful
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



}








