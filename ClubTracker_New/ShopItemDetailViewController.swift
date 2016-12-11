//
//  ShopItemDetailViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ShopItemDetailViewController: UIViewController {
    @IBOutlet weak var imgClubLogo: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    
    @IBOutlet weak var lblSmallSizeItem: UILabel!
    @IBOutlet weak var lblMediumSizeItem: UILabel!
    @IBOutlet weak var lblLargeSizeItem: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var textViewDetails: UITextView!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblClassName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    var paramsSizeQty = [Option]()
    var itemDetails = shopItemDetails()
    
    
    
    var itemId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name" : "child_name") as? String
        // Do any additional setup after loading the view.
          tableView.register(UINib(nibName: "sizeQtyCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        btnRemove.isEnabled = !(Helper.getUserInfo()?.isTeacher)! ? false : true
       btnEdit.isEnabled = !(Helper.getUserInfo()?.isTeacher)! ? false: true
        
        if Helper.getUserInfo()?.avatar_link != nil{
            Helper.loadImageFromUrl(url: (Helper.getUserInfo()?.avatar_link!)!, view: imgClubLogo)
        }
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
        let addItemVC = AddShopItemViewController(nibName: "AddShopItemViewController", bundle: nil)
        addItemVC.isUpdate = true
        addItemVC.updateDataDetails = itemDetails
        self.navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        var params = [String: String]()
        params["item_id"] = "\(itemId)"
        removeShopItem(params, onCompletion:{
            success in
            if success{
            self.navigationController?.popViewController(animated: true)
            }
        })
    }
    //MARK:- Custom Function
    func update(item:shopItemDetails){
        lblPrice.text = "£\(item.price!)"
        if (item.isDelivery == 1){
            if item.charge != 0{
            lblDelivery.text = "delivary avialable with charge £\(item.charge!)"
            }
            else{
                 lblDelivery.text = "free delivery service"
            }
        }
        else{
            lblDelivery.text = "No delivary avialable"
        }
        
        imgPicture.image =
            URL(string: item.image!)
                .flatMap { NSData(contentsOf: $0) }
                .flatMap { UIImage(data: $0 as Data) }
        
        lblItemName.text = item.item_title
       // imgPicture.image = UIImage(named:item.image!)
        textViewDetails.text = item.details
        paramsSizeQty = item.options
        
        itemDetails = item
        tableView.reloadData()
        
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
                            item.isDelivery = Int(items["posting"] as! String)
                            item.charge = Double((items["charge"] as? String)!)
                            item.image = (items["images"] as! [String:AnyObject])["original"] as? String
                            item.price = Double((items["price"] as? String)!)
                            item.item_title = items["item_title"] as? String
                            item.details = items["description"] as? String
                            
                            var options = [Option]()
                            let opt = items["options"] as! [[String:AnyObject]]
                            for itm in opt{
                                let opt = Option()
                                opt.id = Int(itm["option_id"] as! String)
                                opt.quantity = itm["stock"] as? String
                                opt.title = itm["title"] as? String
                                options += [opt]
                            }
                            item.options = options
                            
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
                        
                    case 200 : //Successfully
                            onCompletion(true)
                    case 404:
                        
                        //self?.showAlertOnMainThread(" Record Not Found")
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

extension ShopItemDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramsSizeQty.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! sizeQtyCell
            cell.setupCell(size: paramsSizeQty[indexPath.row].title!, qty: paramsSizeQty[indexPath.row].quantity!)
            return cell
            
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
            return 26
        
    }
    
  
}
