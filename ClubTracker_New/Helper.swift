//
//  Helper.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/14/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class Helper: NSObject{

    static func getScreenWidth() -> CGFloat {
        
        return UIScreen.mainScreen().bounds.width
        
    }
    
    static func getScreenHeight() -> CGFloat {
        
        return UIScreen.mainScreen().bounds.height
        
    }
    
    
    static func getHeightDifference(contentSize: CGFloat) -> CGFloat {
        
        let viewHeight = Helper.getScreenHeight() - kExternalViewHeight
        if  contentSize < viewHeight {
            let diff = viewHeight - contentSize
            return diff
        }
        return 0.0
    }
    
    static func getHeightDifferenceWithoutTab(contentSize: CGFloat) -> CGFloat {
        
        let viewHeight = Helper.getScreenHeight() - kNavbarHeight
        if  contentSize < viewHeight {
            let diff = viewHeight - contentSize
            return diff
        }
        return 0.0
    }
    


    static func getUniqueDeviceId() -> String {
        
        var UUID: String? = NSUserDefaults.standardUserDefaults().valueForKey("UUID") as? String
        
        if (UUID != nil){
            return UUID!
        }
        else {
            
            UUID = NSUUID().UUIDString
            NSUserDefaults.standardUserDefaults().setValue(UUID, forKey: "UUID")
            return UUID!
            
        }
        
    }
    
    //MARK: TextField Validator
    
    static func isValidFullname(name: String) -> Bool{
        let fullNameRegex: NSString   = "^[a-zA-Z ]*$"
        let fullNameText: NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        
        return fullNameText.evaluateWithObject(name)
        
        
    }

    
    static func isNotBlank(name: String) -> Bool{
        
        if !name.isEmpty{
            return true
        }
        return false
        
    }
    
    static func isContainsInStreetList(name: String) -> Bool {
        
        if  AutoComplete.sharedInstance.pupilName.contains(name){
            return true
        }
        return false
    }
    
    
    
    //MARK: TableView Design
   static func setTableViewDesign(tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowOffset = CGSizeMake(0, 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
              
    }
    

}

extension UIViewController {
    
    // MARK: - Show alert method
    
    func showAlertOnMainThread(message: String = "Something went wrong.\nPlease try again later.") {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alert = UIAlertController(title: kApplicationName, message: message, preferredStyle: .Alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func showAlertTitleMessageOnMainThread(titleHead: String, message: String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alert = UIAlertController(title: titleHead, message: message, preferredStyle: .Alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    
}


