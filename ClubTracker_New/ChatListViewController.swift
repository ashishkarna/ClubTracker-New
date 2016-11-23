//
//  ChatListViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/23/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    
    @IBOutlet weak var lblClassName: UILabel!

    @IBOutlet weak var tableChatList: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    var chatMessageList = [ChatDetail]()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
   
}


//MARK: Button Action Method

extension ChatListViewController{
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let createChatVC = CreateChatViewController(nibName: "CreateChatViewController",bundle: nil)
        self.navigationController?.pushViewController(createChatVC, animated: true)
        
    }
    
    
    
}

//MARK: TableView Delegate
extension ChatListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxMessageTableViewCell
        cell.lblTo.text = " Chat name: "
        cell.lblDate.text = " Time: "
        cell.lblSubject.text = " Last message: "
        cell.lblTime.isHidden = true
     
        let chatMessage = chatMessageList[indexPath.row]
        
        cell.lblTo.text = cell.lblTo.text! + chatMessage.chat_name!
        cell.lblDate.text = cell.lblDate.text! + Helper.getTime(chatMessage.last_message_time!)
        cell.lblSubject.text = cell.lblSubject.text! + chatMessage.last_message!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatDetailVC = ChatDetailViewController(nibName:"ChatDetailViewController", bundle: nil )
        chatDetailVC.sentMember = chatMessageList[indexPath.row]
        self.navigationController?.pushViewController(chatDetailVC, animated: true)
        
    }
    
    
}

//MARK: View Controller Helper Method
extension ChatListViewController{
    func setChatList(_ data: [AnyObject]){
        chatMessageList.removeAll()
        for singleItem in data{
            
            let item = singleItem as! [String:AnyObject]
            let singleChat = ChatDetail()
            singleChat.id = item["id"] as? String
            singleChat.uuid = item["uuid"] as? String
            singleChat.created_by = item["created_by"] as? String
            singleChat.chat_name = item["chat_name"] as? String
            singleChat.status = item["status"] as? String
            singleChat.unseen_chats = item["unseen_chats"] as? String
            singleChat.last_message = item["last_message"] as? String
            singleChat.last_message_time = item["last_message_time"] as? String
            
            chatMessageList.append(singleChat)
            
        }
        if chatMessageList.count > 6{
            tableHeight.constant = CGFloat(6 * 45)
        }
        else{
            tableHeight.constant = CGFloat(chatMessageList.count * 45)
        }
        tableChatList.isHidden = false
        tableChatList.reloadData()
        
    }
    
}


//MARK: Web Service Helper Method
extension ChatListViewController{
    
    
    func getChatLists(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getChatLists(onCompletion: {[weak self]
            response in
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        if let outboxData = responseData as? [String: AnyObject]{
                            
                            if let responseResult = outboxData["response"] as? [String:AnyObject]{
                                let chatList = responseResult["chats"] as? [AnyObject]
                                if (chatList?.count)! > 0{
                                    self?.setChatList(chatList!)
                                    
                                    
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
    
}




