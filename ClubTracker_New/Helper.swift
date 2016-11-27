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
        
        return UIScreen.main.bounds.width
        
    }
    
    static func getScreenHeight() -> CGFloat {
        
        return UIScreen.main.bounds.height
        
    }
    
    
    static func getHeightDifference(_ contentSize: CGFloat) -> CGFloat {
        
        let viewHeight = Helper.getScreenHeight() - kExternalViewHeight
        if  contentSize < viewHeight {
            let diff = viewHeight - contentSize
            return diff
        }
        return 0.0
    }
    
    static func getHeightDifferenceWithoutTab(_ contentSize: CGFloat) -> CGFloat {
        
        let viewHeight = Helper.getScreenHeight() - kNavbarHeight
        if  contentSize < viewHeight {
            let diff = viewHeight - contentSize
            return diff
        }
        return 0.0
    }
    


    static func getUniqueDeviceId() -> String {
        
        var UUID: String? = UserDefaults.standard.value(forKey: "UUID") as? String
        
        if (UUID != nil){
            return UUID!
        }
        else {
            
            UUID = Foundation.UUID().uuidString
            UserDefaults.standard.setValue(UUID, forKey: "UUID")
            return UUID!
            
        }
        
    }
    
    //MARK: UserInfo
    static func setUserInfo( userinfo: UserInfo?) {
        
       // let data: NSData? = ((userinfo == nil) ? nil : NSKeyedArchiver.archivedDataWithRootObject(userinfo!)) as Data
        let data: NSData? = (userinfo == nil ? nil : NSKeyedArchiver.archivedData(withRootObject: userinfo!) as NSData)
        UserDefaults.standard.setValue(data, forKey: "USERINFO")
        UserDefaults.standard.synchronize()
        
    }
    
    static func getUserInfo() -> UserInfo? {
        
        let data: NSData? = UserDefaults.standard.value(forKey: "USERINFO") as? NSData
        return ((data == nil) ? nil : (NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? UserInfo)!)
        
    }

    
    
    //MARK: TextField Validator
    
    static func isValidFullname(_ name: String) -> Bool{
        let fullNameRegex: NSString   = "^[a-zA-Z ]*$"
        let fullNameText: NSPredicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        
        return fullNameText.evaluate(with: name)
        
        
    }

    static func isSameText(_ firstStr: String, secondStr: String) -> Bool {
        if firstStr == secondStr {
            return true
        }
        return false
    }

    
    static func isNotBlank(_ name: String) -> Bool{
        
        if !name.isEmpty{
            return true
        }
        return false
        
    }
    
    static func isContainsInStreetList(_ name: String) -> Bool {
        
        if  AutoComplete.sharedInstance.pupilName.contains(name){
            return true
        }
        return false
    }
    
    
    //MARK: DATE AND TIME FORMATTER
    static func getDate(_ dateString: String)-> String{
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: date!)
        return stringDate
        
    }
    
    static func getSimpleTime(_ timeString:String)->String{
    
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        let date = formatter.date(from: timeString)
        
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: date!)
        return time
        
    }
    
    static func getTime(_ dateString: String)-> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        
        formatter.dateFormat = "hh:mm:ss a"
        let stringDate = formatter.string(from: date!)
        return stringDate
        
    }
    
    //MARK: TableView Design
   static func setTableViewDesign(_ tableView: UITableView){
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowOpacity = 0.2
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 1.0
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 2.0
        tableView.layer.masksToBounds = true
        
              
    }
    
    
    

}

extension UIViewController {
    
    // MARK: - Show alert method
    
    func showAlertOnMainThread(_ message: String = "Something went wrong.\nPlease try again later.") {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: kApplicationName, message: message, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func showAlertTitleMessageOnMainThread(_ titleHead: String, message: String) {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: titleHead, message: message, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    
    
    
}


