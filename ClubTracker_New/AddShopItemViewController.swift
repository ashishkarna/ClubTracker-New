//
//  AddShopItemViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class AddShopItemViewController: UIViewController {

    
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var txtSizeQty: UITextField!
    
    @IBOutlet weak var txtDelievery: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}

//MARK: Button Action
extension AddShopItemViewController{

    @IBAction func btnBack(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnTakePhoto(sender: UIButton) {
    }
    


}
