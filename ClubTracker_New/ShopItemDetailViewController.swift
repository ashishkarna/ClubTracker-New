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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
extension ShopItemDetailViewController{

    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnStockEdit(sender: UIButton) {
    }
    
    @IBAction func btnAddItem(sender: UIButton) {
    }
    

}
