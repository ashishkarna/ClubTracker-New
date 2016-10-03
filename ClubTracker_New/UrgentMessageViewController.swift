//
//  UrgentMessageViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/2/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UrgentMessageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        tableView.registerNib(UINib(nibName: "MessageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MessageCell")
        
        Helper.setTableViewDesign(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//Button Action

extension UrgentMessageViewController{

    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func btnSwitchTapped(sender: UISwitch) {
    }

    
    
}

extension UrgentMessageViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
          let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageTableViewCell
            
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = MessageDetailViewController(nibName: "MessageDetailViewController", bundle: nil)
        detailVC.navTitle = "Urgent"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
