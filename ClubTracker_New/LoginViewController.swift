//
//  LoginViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnTeacherOutlet: UIButton!
  
    var isTeacherButtonPressed = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  bottomConstant.constant += Helper.getHeightDifferenceWithoutTab(scrollView.content)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}

//MARK: Button Action
extension LoginViewController{
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        //check validation 
        validateField()
        
    }
    @IBAction func btnIsTeacherPressed(_ sender: UIButton) {
        isTeacherButtonPressed = !isTeacherButtonPressed
        if isTeacherButtonPressed {
            btnTeacherOutlet.setBackgroundImage(UIImage(named: "checkIcon"), for: UIControlState())
            
        }
        else{
            btnTeacherOutlet.setBackgroundImage(UIImage(named: "unCheckIcon"), for: UIControlState())
        }
        
        
        
    }
    
    ///check validation
    func validateField(){
        
        var params = [String: String]()
        var  hasError = false
        var errorMessage = ""
        
        if Helper.isNotBlank(txtUsername.text!){
            params["email"] = txtUsername.text
            if Helper.isNotBlank(txtPassword.text!) {
                params["password"] = txtPassword.text
                
                params["user_type"] = isTeacherButtonPressed ? "3" : "4"
                
            }
                
            else{
                
                hasError = true
                errorMessage = "Please enter password"
            }
            
        }
            
        else{
            
            hasError = true
            errorMessage = "Please enter username"
            
        }
        
        if hasError{
            
            self.showAlertOnMainThread(errorMessage)
            
        }
        else{
           // gotoNextPage()
            checkUser(params)
        }
    }

    
    ///goto next view controller
    func gotoNextPage(){
        let selectVC = SelectClassViewController(nibName: "SelectClassViewController", bundle: nil)
        selectVC.isTeacher = isTeacherButtonPressed ? true: false
        self.navigationController?.pushViewController(selectVC, animated: true)
    }

}



//MARK: Web Service Helper Method
extension LoginViewController{
    
    func checkUser(_ params: [String: String]){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.login(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let userData = responseData as? [String: AnyObject] {
                            
                                UserDefaults.standard.setValue(userData["token"], forKey: "userToken")
                            
                                //1.get user detail
                            self!.getUserDetail()
                            //2. goto next page
                            
                            }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                   
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            })
        
    }

    
    func getUserDetail(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getUser(nil, onCompletion: { [weak self]
            response in
           
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let userData = responseData as? [String: AnyObject] {
                            let user = userData["user"] as? [String: AnyObject]
                            let club = userData["club"] as? [String:AnyObject]
                            let profile = userData["profile"] as? [String: AnyObject]
                            UserDefaults.standard.setValue(club!["logo_link"], forKey: "clubLogo")
                            UserDefaults.standard.setValue(profile!["club_id"],forKey:"club_id")
                            UserDefaults.standard.setValue(profile?["user_id"], forKey: "user_id")
                            let userInfo = UserInfo()
                            
                            userInfo.user_id = profile?["user_id"] as? String
                            userInfo.club_id = profile?["club_id"] as? String
                            userInfo.first_name = profile?["first_name"] as? String
                            userInfo.avatar_link = profile?["avatar_link"] as? String
                            userInfo.isTeacher = user?["user_type"] as! String == "3" ? true : false
                            Helper.setUserInfo(userinfo: userInfo)
                            //go to next page
                            self!.gotoNextPage()
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                        
                    case 500: // Internal Server Error
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    
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
