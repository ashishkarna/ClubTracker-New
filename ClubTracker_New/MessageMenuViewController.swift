//
//  MessageMenuViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class MessageMenuViewController: UIViewController {

    @IBOutlet weak var lblClassName: UILabel!
    var isTeacher = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name" : "child_name") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }

//MARK: BUTTON Action
extension MessageMenuViewController{

    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    @IBAction func btnNew(_ sender: UIButton) {
     
        let newMessageVC = NewMessageViewController(nibName: "NewMessageViewController", bundle: nil)
        self.navigationController?.pushViewController(newMessageVC, animated: true)
    }
    

    @IBAction func btnUrgentMessage(_ sender: UIButton) {
        if !isTeacher{
            self.showAlertOnMainThread("Sorry! Only Teacher have access to it.")
        }
        else{
        let urgentVC = UrgentMessageViewController(nibName: "UrgentMessageViewController", bundle: nil)
       
        self.navigationController?.pushViewController(urgentVC, animated: true)
        }
    }

    
    @IBAction func btnInbox(_ sender: UIButton) {
        let inboxVC = InboxViewController(nibName: "InboxViewController", bundle: nil)
        self.navigationController?.pushViewController(inboxVC, animated: true)
    }
    
    @IBAction func btnOutbox(_ sender: UIButton) {
        let outboxVC = OutboxViewController(nibName: "OutboxViewController", bundle: nil)
        self.navigationController?.pushViewController(outboxVC, animated: true)
    }
    
}
