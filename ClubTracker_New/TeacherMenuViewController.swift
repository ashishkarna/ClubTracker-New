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
    var isTeacher = false
    
    @IBOutlet weak var lblNavTitle: UILabel!
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
       lblNavTitle.text = UserDefaults.standard.value( forKey: isTeacher ? "class_name": "child_name") as? String
        let nib = UINib(nibName: "TeacherMenuItemCell", bundle: Bundle.main)
        
       collectionView.register(nib, forCellWithReuseIdentifier: "TeacherMenuItemCell")
       

        menuImage[0] = isTeacher ? "register-icon" : "responseMessage"
        menuTitle[0] = isTeacher ? "Register" : "Response"
        
      
    }

    override func viewWillAppear(_ animated: Bool) {
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


    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
      // self.navigationController?.popViewControllerAnimated(true)
    }

}

//MARK: --Collection view delegates
extension TeacherMenuViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        let widthINR = (UIScreen.main.bounds.size.width - 20) / 3
        let cellSize:CGSize = CGSize(width: widthINR, height: widthINR)
        return cellSize
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherMenuItemCell", for: indexPath) as! TeacherMenuItemCell
        cell.imgBG.image = UIImage(named: menuImage[indexPath.row])
        cell.viewScore.isHidden = true
        cell.lblMenuTitle.text = menuTitle[indexPath.row]
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        didMenuSelect(indexPath.row)
}
    
    func didMenuSelect(_ menuIndex: Int){
        
        switch menuIndex {
        case 0:
            if isTeacher {
            let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
            self.navigationController?.pushViewController(registerVC, animated: true)
            }
            else{
                let responseVC = ResponseMessageViewController(nibName: "ResponseMessageViewController", bundle: nil)
                self.navigationController?.pushViewController(responseVC, animated: true)
            }
          
        case 1:
            let messageVC = MessageMenuViewController(nibName: "MessageMenuViewController", bundle: nil)
            if isTeacher{
                messageVC.isTeacher = true
            }
            self.navigationController?.pushViewController(messageVC, animated: true)
            
        case 2:
            let chatVC = ChatViewController(nibName:"ChatViewController", bundle:nil)
            self.navigationController?.pushViewController(chatVC, animated: true)
            
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
