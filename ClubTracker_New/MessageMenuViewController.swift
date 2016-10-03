//
//  MessageMenuViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class MessageMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }

//MARK: BUTTON Action
extension MessageMenuViewController{

    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    @IBAction func btnNew(sender: UIButton) {
     
        let newMessageVC = NewMessageViewController(nibName: "NewMessageViewController", bundle: nil)
        self.navigationController?.pushViewController(newMessageVC, animated: true)
    }
    

    @IBAction func btnUrgentMessage(sender: UIButton) {
        let urgentVC = UrgentMessageViewController(nibName: "UrgentMessageViewController", bundle: nil)
       
        self.navigationController?.pushViewController(urgentVC, animated: true)
    }

    
    @IBAction func btnInbox(sender: UIButton) {
        let inboxVC = InboxViewController(nibName: "InboxViewController", bundle: nil)
        self.navigationController?.pushViewController(inboxVC, animated: true)
    }
    
    @IBAction func btnOutbox(sender: UIButton) {
        let outboxVC = OutboxViewController(nibName: "OutboxViewController", bundle: nil)
        self.navigationController?.pushViewController(outboxVC, animated: true)
    }
    
}
