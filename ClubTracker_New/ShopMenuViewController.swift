//
//  ShopMenuViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class ShopMenuViewController: UIViewController {
    
    @IBOutlet weak var txtSearchItem: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- variable declaration
    var numberOfColumn = 1
    var shopItemList = [ShopItemList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "ShopListItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShopCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllShopItems(nil, onCompletion:{
            success in
            
            
            
        })
        
    }
    
    
}
//MARK: BUTTON ACTION
extension ShopMenuViewController{
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddShopItem(_ sender: UIButton) {
        
        let addItemVC = AddShopItemViewController(nibName: "AddShopItemViewController", bundle: nil)
        self.navigationController?.pushViewController(addItemVC, animated: true)
        
    }
    
    //MARK:- Custom Function
    func getAllShopItems(_ params: [String: String]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebServiceHelper.getAllShopItems(params as [String : AnyObject]?, onCompletion: { [weak self]
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
                            let itemList = shopItemList["items"] as? [AnyObject]
                            self?.shopItemList.removeAll()
                            if (itemList?.count)! > 0{
                                
                                for items in itemList! {
                                    let itm = items as! [String:AnyObject]
                                    let item = ShopItemList()
                                    item.id = Int((itm["id"] as? String)!)
                                    item.available_options = itm["item_title"] as? String
                                    item.charge = Double((itm["charge"] as? String)!)
                                    item.image = itm["image"] as? String
                                    item.price = Double((itm["price"] as? String)!)
                                    item.item_title = itm["available_options"] as? String
                                    self?.shopItemList += [item]
                                }
                                self!.collectionView.reloadData()
                                onCompletion(true)
                            }
                            else{
                                
                                self?.showAlertOnMainThread("No Result Found")
                            }
                            
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

//MARK: --Collection delegate
extension ShopMenuViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopItemList.count
    }
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        //        let width = ((UIScreen.mainScreen().bounds.size.width - 8) / (CGFloat)(numberOfColumn))
        //        let cellSize:CGSize = CGSizeMake(width, 100)
        //        return cellSize
        
        let widthINR = (collectionView.bounds.size.width - 10) / 2
        let cellSize:CGSize = CGSize(width: widthINR, height: widthINR)
        return cellSize
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopListItemCell
        
        
        cell.imgView.image = UIImage(named: "icon.png")
        cell.lblItemName.text = shopItemList[indexPath.row].item_title
        cell.lblItemColor.text = shopItemList[indexPath.row].available_options
        cell.lblItemPrice.text = "\(shopItemList[indexPath.row].price)"
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let itemDetailVC = ShopItemDetailViewController(nibName: "ShopItemDetailViewController", bundle: nil)
        itemDetailVC.itemId = shopItemList[indexPath.row].id!
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}
