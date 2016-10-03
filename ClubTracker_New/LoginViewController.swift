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
    
  
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
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
    
    ///check validation
    func validateField(){
        
        var  hasError = false
        var errorMessage = ""
        
        if Helper.isNotBlank(txtUsername.text!){
            
            if Helper.isNotBlank(txtPassword.text!) {
                //Ok
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
            gotoNextPage()
        }
    }

    
    ///goto next view controller
    func gotoNextPage(){
        let selectVC = SelectClassViewController(nibName: "SelectClassViewController", bundle: nil)
        self.navigationController?.pushViewController(selectVC, animated: true)
    }

}
