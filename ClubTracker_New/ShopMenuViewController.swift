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
        collectionView.registerNib(UINib(nibName: "ShopListItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "ShopCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
//MARK: BUTTON ACTION
extension ShopMenuViewController{
    
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnAddShopItem(sender: UIButton) {
        
        let addItemVC = AddShopItemViewController(nibName: "AddShopItemViewController", bundle: nil)
        self.navigationController?.pushViewController(addItemVC, animated: true)
        
    }
    
    
    
}

//MARK: --Collection delegate
extension ShopMenuViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
//        let width = ((UIScreen.mainScreen().bounds.size.width - 8) / (CGFloat)(numberOfColumn))
//        let cellSize:CGSize = CGSizeMake(width, 100)
//        return cellSize
      
        let widthINR = (collectionView.bounds.size.width - 10) / 2
        let cellSize:CGSize = CGSizeMake(widthINR, widthINR)
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShopCell", forIndexPath: indexPath) as! ShopListItemCell
        
        
        cell.imgView.image = UIImage(named: "icon.png")
        cell.lblItemName.text = "ItemName"
        cell.lblItemColor.text = "Color"
        cell.lblItemPrice.text = "Price"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        let itemDetailVC = ShopItemDetailViewController(nibName: "ShopItemDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}
