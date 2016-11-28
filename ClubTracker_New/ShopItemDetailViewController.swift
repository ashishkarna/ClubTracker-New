//
//  ShopItemDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ShopItemDetailViewController: UIViewController {
    
    
    @IBOutlet weak var lblSmallSizeItem: UILabel!
    @IBOutlet weak var lblMediumSizeItem: UILabel!
    @IBOutlet weak var lblLargeSizeItem: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var textViewDetails: UITextView!
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    
    
    var itemId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var params = [String: String]()
        params["item_id"] = String(itemId)
        getShopItemDetails(params, onCompletion:{
            success in
            
        })
    }
    
    
    
}
extension ShopItemDetailViewController{
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStockEdit(_ sender: UIButton) {
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        var params = [String: String]()
        params["item_id"] = String(itemId)
        removeShopItem(params, onCompletion:{
            success in
            
        })
    }
    //MARK:- Custom Function
    func update(item:shopItemDetails){
        lblPrice.text = "$\(item.price)"
        if (item.available_options == "1"){
            lblDelivery.text = "delivary avialable with charge $\(item.charge)"
        }
        else{
            lblDelivery.text = "delivary not avialable"
        }
        lblItemName.text = item.item_title
        lblLargeSizeItem.text = "Large: \(item.large) items"
        lblSmallSizeItem.text = "Small: \(item.small) items"
        lblMediumSizeItem.text = "Medium: \(item.medium) items"
        imgPicture.image = UIImage(named:item.image!)
        textViewDetails.text = item.details
        
        
    }
    func getShopItemDetails(_ params: [String: String]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getDetailShopItems(params as [String : AnyObject]?, onCompletion: { [weak self]
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
                            let items = shopItemList["item"] as! [String:AnyObject]
                            
                            let item = shopItemDetails()
                            item.id = Int((items["id"] as? String)!)
                            item.available_options = items["item_title"] as? String
                            item.charge = Double((items["charge"] as? String)!)
                            item.image = items["image"] as? String
                            item.price = Double((items["price"] as? String)!)
                            item.item_title = items["available_options"] as? String
                            item.details = items["available_options"] as? String
                            item.large = Int((items["available_options"] as! String))
                            item.medium = Int((items["available_options"] as! String))
                            item.small = Int((items["available_options"] as! String))
                            self?.update(item: item)
                            onCompletion(true)
                        }
                        else{
                            
                            self?.showAlertOnMainThread("No Result Found")
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
    //MARK:- Custom Function
    func removeShopItem(_ params: [String: String]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.removeHopItem(params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            //  print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved attendance
                        
                        if let _ = responseData as? [String: AnyObject] {
                            onCompletion(true)
                        }
                        else{
                            
                            self?.showAlertOnMainThread("fail")
                        }
                        
                        //    case 301: //already taken
                    //       // self?.showAlertOnMainThread("Attendance already taken")
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
