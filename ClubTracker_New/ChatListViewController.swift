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
    var isComingFromCreateChat = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(Helper.getUserInfo()?.isTeacher!)
        lblClassName.text = UserDefaults.standard.value(forKey: (Helper.getUserInfo()?.isTeacher!)! ? "class_name": "child_name") as? String
        tableChatList.register(UINib(nibName: "ChatListCell", bundle: Bundle.main), forCellReuseIdentifier: "ChatListCell")
        Helper.setTableViewDesign(tableChatList)
        tableChatList.isHidden = true

        getChatLists()
    }

    override func viewWillAppear(_ animated: Bool) {
        isComingFromCreateChat = (UserDefaults.standard.value(forKey: "isComingFromCreateChat") != nil)
        if isComingFromCreateChat{
            getChatLists()
            UserDefaults.standard.removeObject(forKey: "isComingFromCreateChat")
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        cell.lblChatName.text = " Chat name: "
        cell.lblTime.text = " Time: "
        cell.lblLastMessage.text = " Last message: "
       
     
        let chatMessage = chatMessageList[indexPath.row]
        if chatMessage.chat_name != nil{
        cell.lblChatName.text = cell.lblChatName.text! + chatMessage.chat_name!
        }
        if chatMessage.last_message != nil{
        cell.lblTime.text = cell.lblTime.text! + Helper.getTime(chatMessage.last_message_time!)
        }
        if chatMessage.last_message != nil{
        cell.lblLastMessage.text = cell.lblLastMessage.text! + chatMessage.last_message!
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
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
//        if chatMessageList.count > 6{
//            tableHeight.constant = CGFloat(6 * 65)
//        }
//        else{
//           tableHeight.constant = CGFloat(chatMessageList.count * 65)
//        }
        tableChatList.isHidden = false
        chatMessageList.reverse()
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




