//
//  ChatDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/23/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var tableChat: UITableView!
    

    var sentMember = ChatDetail()
    var chatsOfChatList = [ChatsOfChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       btnAdd.isHidden = true
       tableChat.register(UINib(nibName: "ChatCell",bundle: Bundle.main), forCellReuseIdentifier: "ChatCell")
        tableChat.register(UINib(nibName: "UserChatCell",bundle: Bundle.main), forCellReuseIdentifier: "UserChatCell")
        tableChat.estimatedRowHeight = 200
       tableChat.rowHeight = UITableViewAutomaticDimension
       // Helper.setTableViewDesign(tableMember)
        tableChat.isHidden = true
        getChatsOfChat()
   

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
 
}


//MARK: Button Action Method

extension ChatDetailViewController{
    

    @IBAction func buttonBackPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addChatMemberButtonPressed(_ sender: UIButton) {
    // add possible chat member in group
        
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        //send message / chat
        if Helper.isNotBlank(textMessage.text!){
            let params:[String: AnyObject] = ["uuid": (sentMember.uuid! as AnyObject?)!,"message": (textMessage.text! as AnyObject?)!]
        
          
            print(params)
            self.sendChatMessage(params)
            
        }
        
    }
    
}



//MARK: TableView Delegate 

extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatsOfChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // var cell = UITableViewCell()
         let chatMessage = chatsOfChatList[indexPath.row]
        if sentMember.created_by == chatMessage.member_id{
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell") as! UserChatCell
           
            if chatMessage.message != nil {
               cell.lblChatMessage.text = chatMessage.message
            }

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            if chatMessage.message != nil {
                cell.lblChatMessage.text = chatMessage.message
                
                
            }
            return cell
            
        }

    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
 
    
}


//MARK: View Controller Helper Method
extension ChatDetailViewController{
    func setChatsofChat(_ data: [AnyObject]){
        chatsOfChatList.removeAll()
        for singleItem in data{
            
            let item = singleItem as! [String:AnyObject]
            let singleChatMessage = ChatsOfChat()
            singleChatMessage.chat_id = item["chat_id"] as? String
            singleChatMessage.member_id = item["member_id"] as? String
            singleChatMessage.member_name = item["member_name"] as? String
            singleChatMessage.message = item["message"] as? String
 
            chatsOfChatList.append(singleChatMessage)
            
        }
       
        
        tableChat.isHidden = false
        tableChat.reloadData()
    }



}


//MARK: Web Service Helper Method
extension ChatDetailViewController{
    func getChatsOfChat(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params:[String: Any] = ["uuid": sentMember.uuid!]
        WebServiceHelper.getChatsofChat(params as [String : AnyObject]?,onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let chatMessages = responseResult["chats"] as? [AnyObject]
                                if (chatMessages?.count)! > 0{
                                    self?.setChatsofChat(chatMessages!)
                                    
                                    
                                }
                                else{
                                    self?.showAlertOnMainThread("No Result Found")
                                }
                                
                            }
                            
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

    
    func sendChatMessage(_ params: [String: AnyObject]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.sendChatMessage(params as [String : AnyObject]?,onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                       self?.getChatsOfChat()
                       self?.textMessage.text = ""
                        break
                        
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

}




