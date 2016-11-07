//
//  HomeViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit




class TeacherMenuViewController
: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var menuImage = ["register-icon","message-icon","chat-icon","diary-icon","camera-icon","target-icon","shop_icon","social-media","contact-icon"]
    var menuTitle = ["Register","Message","Chat","Diary","Camera","Target/Stats","Shop","Social Media","Contact US"]
    
    @IBOutlet weak var lblNavTitle: UILabel!
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       lblNavTitle.text = NSUserDefaults.standardUserDefaults().valueForKey("class_name") as? String
        let nib = UINib(nibName: "TeacherMenuItemCell", bundle: NSBundle.mainBundle())
        
       collectionView.registerNib(nib, forCellWithReuseIdentifier: "TeacherMenuItemCell")

      
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // (self.navigationController?.tabBarController as! TabBarController)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

//MARK: Button Action
extension TeacherMenuViewController{


    @IBAction func btnBack(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
      // self.navigationController?.popViewControllerAnimated(true)
    }

}

//MARK: --Collection view delegates
extension TeacherMenuViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let widthINR = (UIScreen.mainScreen().bounds.size.width - 20) / 3
        let cellSize:CGSize = CGSizeMake(widthINR, widthINR)
        return cellSize
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TeacherMenuItemCell", forIndexPath: indexPath) as! TeacherMenuItemCell
        cell.imgBG.image = UIImage(named: menuImage[indexPath.row])
        cell.viewScore.hidden = true
        cell.lblMenuTitle.text = menuTitle[indexPath.row]
        
        cell.backgroundColor = UIColor.whiteColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        didMenuSelect(indexPath.row)
}
    
    func didMenuSelect(menuIndex: Int){
        
        switch menuIndex {
        case 0:
            let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
            self.navigationController?.pushViewController(registerVC, animated: true)
          
        case 1:
            let messageVC = MessageMenuViewController(nibName: "MessageMenuViewController", bundle: nil)
            self.navigationController?.pushViewController(messageVC, animated: true)
            
            
        case 5:
            let targetVC = TargetVC(nibName: "TargetVC", bundle: nil)
            self.navigationController?.pushViewController(targetVC, animated: true)
        
        case 6:
            let shopVC = ShopMenuViewController(nibName: "ShopMenuViewController",bundle: nil)
            self.navigationController?.pushViewController(shopVC, animated: true)
            
        case 7:
            let socialVC = SocialMediaVC(nibName: "SocialMediaVC",bundle: nil)
            self.navigationController?.pushViewController(socialVC, animated: true)
            
        case 8:
            let contactVC = ContactUsVC(nibName: "ContactUsVC",bundle: nil)
            self.navigationController?.pushViewController(contactVC, animated: true)
            
        default:
            break
        }
    }
  
}