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
    
    @IBAction func btnLogin(sender: UIButton) {
        
        //check validation 
        validateField()
        
    }
    @IBAction func btnIsTeacherPressed(sender: UIButton) {
        isTeacherButtonPressed = !isTeacherButtonPressed
        if isTeacherButtonPressed {
            btnTeacherOutlet.setBackgroundImage(UIImage(named: "checkIcon"), forState: .Normal)
            
        }
        else{
            btnTeacherOutlet.setBackgroundImage(UIImage(named: "unCheckIcon"), forState: .Normal)
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
        self.navigationController?.pushViewController(selectVC, animated: true)
    }

}



//MARK: Web Service Helper Method
extension LoginViewController{
    
    func checkUser(params: [String: String]){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.login(params, onCompletion: { [weak self]
            response in
            print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let userData = responseData as? [String: AnyObject] {
                            
                                NSUserDefaults.standardUserDefaults().setValue(userData["token"], forKey: "userToken")
                            
                                //1.get user detail
                            self!.getUserDetail()
                            //2. goto next page
                            
                            }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                   
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.Failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            })
        
    }

    
    func getUserDetail(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        WebServiceHelper.getUser(nil, onCompletion: { [weak self]
            response in
           
            debugPrint(response)
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
            
            switch response.result {
                
            case .Success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successful Login
                        
                        if let userData = responseData as? [String: AnyObject] {
                            
                            let club = userData["club"] as? [String:AnyObject]
                            let profile = userData["profile"] as? [String: AnyObject]
                            NSUserDefaults.standardUserDefaults().setValue(club!["logo_link"], forKey: "clubLogo")
                            NSUserDefaults.standardUserDefaults().setValue(profile!["club_id"],forKey:"club_id")
                            
                            //go to next page
                            self!.gotoNextPage()
                        }
                            
                        else{
                            self?.showAlertOnMainThread(kServerError)
                        }
                        
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                        
                    case 500: // Internal Server Error
                        self?.showAlertOnMainThread(responseData.valueForKey("error") as! String)
                    
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.Failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
            })
        
    }
    
    


}
