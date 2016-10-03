//
//  RegisterViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit


protocol tableListDelegates{
    func tableViewDidselect(indexPath: NSIndexPath)
}


class RegisterViewController: UIViewController {

    @IBOutlet weak var tablePupil: UITableView!
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tablePupil.registerNib(UINib(nibName: "RegisterCell",bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "RegisterCell")
        Helper.setTableViewDesign(tablePupil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
}

//MARK: Button Action
extension RegisterViewController{
    
    @IBAction func btnSwitchTapped(sender: UISwitch) {
        
        
    }
    
    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}




extension RegisterViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
      
        let cell = tableView.dequeueReusableCellWithIdentifier("RegisterCell") as! RegisterCell
        cell.lblName.text = "child name \(indexPath.row + 1) "

        return cell
    }
    
 
}
