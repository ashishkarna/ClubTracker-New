//
//  AddShopItemViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class AddShopItemViewController: UIViewController {
    
    var Large = ""
    var Medium = ""
    var Small = ""
    var isDelivery = 0
    var delivaryCharge = ""
    var tempIsDelivery = 0
    
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblSmall: UILabel!
    @IBOutlet weak var lblLarge: UILabel!
    @IBOutlet weak var lblMedium: UILabel!
    
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtSmallAmount: UITextField!
    @IBOutlet weak var txtMediumAmount: UITextField!
    @IBOutlet weak var txtLargeAmount: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var btnTakeImg: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!
    
    @IBOutlet weak var imgCaptureImage: UIImageView!
    
    @IBOutlet weak var txtDeliveryCharge: UITextField!
    @IBOutlet weak var viewSizeAndQty: UIScrollView!
    
    @IBOutlet weak var viewDelivery: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDeliverTapped(_ sender: Any) {
        txtDeliveryCharge.text = ""
        tempIsDelivery = isDelivery
        viewDelivery.isHidden = false
    }
    
    @IBAction func btnSwitchTapped(_ sender: Any) {
        if isDelivery == 0{
            isDelivery = 1
        }
        else{
            isDelivery = 0
        }
    }
    @IBAction func btnCalcelDeliveryTapped(_ sender: Any) {
        isDelivery = tempIsDelivery
        viewDelivery.isHidden = true
    }
    
    @IBAction func btnDeliveryDone(_ sender: Any) {
        delivaryCharge = txtDeliveryCharge.text!
        viewDelivery.isHidden = true
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        lblLarge.text = "Large : \(txtLargeAmount.text)"
        lblMedium.text = "Medium : \(txtMediumAmount.text)"
        lblSmall.text = "Small : \(txtSmallAmount.text)"
        Large = txtLargeAmount.text!
        Medium = txtMediumAmount.text!
        Small = txtSmallAmount.text!
        viewSizeAndQty.isHidden = true
    }
    
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        viewSizeAndQty.isHidden = true
    }
    
    @IBAction func btnSizeAndQTYTapped(_ sender: Any) {
        txtLargeAmount.text = ""
        txtMediumAmount.text = ""
        txtSmallAmount.text = ""
        viewSizeAndQty.isHidden = false
    }
    
    
    @IBAction func btnAddItemTapped(_ sender: Any) {
        
        
        var params = [String: AnyObject]()
        params["item_title"] =  txtItemName.text as AnyObject?
        params["item_price"] = txtPrice.text as AnyObject?
        params["delivery"] = "1" as AnyObject?
        params["delivery_charge"] = "12" as AnyObject?
        params["description"] = txtDescription.text as AnyObject?
        
        var itemOption = [[String:AnyObject]]()
        itemOption.append(["options":["color":"red" as AnyObject,"size":"5" as AnyObject,
                           "quantity":"3" as AnyObject] as AnyObject]
        )
        itemOption.append(["options":["color":"red" as AnyObject,"size":"5" as AnyObject,
                                      "quantity":"3" as AnyObject] as AnyObject]
        )
        params["item_options"] = itemOption as AnyObject?
        
        addShopItem(params, onCompletion:{
                success in
                
                
                
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
}

//MARK: Button Action
extension AddShopItemViewController{
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTakePhoto(_ sender: UIButton) {
    }
    
    //MARK:- Custom Function
    func addShopItem(_ params: [String: AnyObject]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        WebServiceHelper.addShopItem(selectedImage:imgCaptureImage.image, params:params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            //  print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let shopItemList = responseData as? [String: AnyObject] {
                           // let itemList = shopItemList["items"] as? [AnyObject]
                            
                           // if (itemList?.count)! > 0{
                                
                                
                                
                                onCompletion(true)
                           // }
                           // else{
                                
                           //     self?.showAlertOnMainThread("No Result Found")
                           // }
                            
                        }
                        
                        
                        
                    case 301: //already taken
                        self?.showAlertOnMainThread("Attendance already taken")
                    case 404:
                        
                        //self?.showAlertOnMainThread("Attendance Record Not Found")
                        onCompletion(false)
                    //   self!.isSaved = false
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
    
    
}
