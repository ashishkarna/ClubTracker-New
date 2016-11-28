//
//  HomeViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/1/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
import MobileCoreServices



class TeacherMenuViewController
: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var menuImage = ["register-icon","message-icon","chat-icon","diary-icon","camera-icon","target-icon","shop_icon","social-media","contact-icon"]
    var menuTitle = ["Register","Message","Chat","Diary","Camera","Target/Stats","Shop","Social Media","Contact US"]
    var isTeacher = false
    var imagePicker = UIImagePickerController()
    var isLibrary = false
    var isCameraOpen = false
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
        if isCameraOpen{
            cameraOpen()
        }
        
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
            let chatVC = ChatListViewController(nibName:"ChatListViewController", bundle:nil)
            self.navigationController?.pushViewController(chatVC, animated: true)
            break
        case 3:
            let diaryVC = DiaryViewController(nibName: "DiaryViewController", bundle: nil)
            diaryVC.isTeacher = (Helper.getUserInfo()?.isTeacher)! 
            self.navigationController?.pushViewController(diaryVC, animated: true)
            break
        case 4:
            cameraOpen()
            break
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


//MARK: Camera Helper Method 
extension TeacherMenuViewController{

    func cameraOpen(){
        //imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
      
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            isCameraOpen = true
            imagePicker = UIImagePickerController() //make a clean controller
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
            
            imagePicker.showsCameraControls = true
            imagePicker.delegate = self  //uncomment if you want to take multiple pictures.
            
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            let customView:CustomOverlayView = customViewController.view as! CustomOverlayView
            customView.frame = CGRect(x: 0, y: 0, width: 320, height: 100)
            //customView.backgroundColor = UIColor.red
            customView.delegate = self
            imagePicker.cameraOverlayView = customView
            
            present(imagePicker,
                    animated: false,
                    completion:nil)
            
        } else { //no camera found -- alert the user.
            
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: false,
                completion: nil)
        }
        
    }


}


//MARK: Camera Delegate Meethod
extension TeacherMenuViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        dismiss(animated: false, completion: nil)
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            if !isLibrary{
                UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, nil, nil)
                let videoData = NSData(contentsOf: pickedVideo as URL)
                let paths = NSSearchPathForDirectoriesInDomains(
                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentsDirectory: AnyObject = paths[0] as AnyObject
                videoData?.write(toFile: documentsDirectory as! String, atomically: false)
            }
            let playerVC = PlayerViewController(
                nibName:"PlayerViewController",
                bundle: nil
            )
            playerVC.isVideo = true
            playerVC.videoURL = pickedVideo
            present(
                playerVC,
                animated: false,
                completion: nil)
        }
        else{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            if isLibrary{
                
            }
            else{
                
                UIImageWriteToSavedPhotosAlbum(chosenImage, self,nil, nil) //save to the photo library
                
            }
            let playerVC = PlayerViewController(
                nibName:"PlayerViewController",
                bundle: nil
            )
            playerVC.isVideo = false
            playerVC.imageSel = chosenImage
            present(
                playerVC,
                animated: false,
                completion: nil)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if isLibrary{
           
            isLibrary = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }
        else{
            isCameraOpen = false
            self.dismiss(animated: true, completion: nil)
        }
        print("Canceled!!")
        
    }


}



//MARK:Camera Custom Delegate
extension TeacherMenuViewController:CustomOverlayDelegate{
    func libraryShow() {
        isLibrary = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
}

