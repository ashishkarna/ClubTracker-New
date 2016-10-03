//
//  InboxViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    
    @IBOutlet weak var tableInbox: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableInbox.registerNib(UINib(nibName: "InboxMessageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "InboxCell")
        Helper.setTableViewDesign(tableInbox)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//Button Action

extension InboxViewController{
    
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
   
    
    
    
}

extension InboxViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InboxCell") as! InboxMessageTableViewCell
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Inbox"
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}


