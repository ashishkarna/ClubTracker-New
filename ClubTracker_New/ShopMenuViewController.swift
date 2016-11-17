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
    
    
    
    var numberOfColumn = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "ShopListItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShopCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
}

//MARK: --Collection delegate
extension ShopMenuViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopListItemCell
        
        
        cell.imgView.image = UIImage(named: "icon.png")
        cell.lblItemName.text = "ItemName"
        cell.lblItemColor.text = "Color"
        cell.lblItemPrice.text = "Price"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let itemDetailVC = ShopItemDetailViewController(nibName: "ShopItemDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}
