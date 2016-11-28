//
//  SocialMediaVC.swift
//  ClubTracker-v1
//
//  Created by Ashish Karna on 9/15/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import AVKit
import UIKit
import AVFoundation
import Social
import MobileCoreServices

class SocialMediaVC: UIViewController {

    @IBOutlet weak var txtVIewDetails: UITextView!
    var isVideo = false
    var videoURL:NSURL?
    var imageSel:UIImage?
    var imagePicker = UIImagePickerController()
    var playerLayer = AVPlayerLayer()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //send
    @IBAction func btnSend(_ sender: UIButton) {
    }

    //back
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Camera Button
    @IBAction func btnCamera(_ sender: UIButton) {
        imagePicker = UIImagePickerController() //make a clean controller
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
        imagePicker.delegate = self

        present(imagePicker,
                animated: false,
                completion:nil)

    }
    

    
    //MARK: Social Media
    
    ///Update on Facebook
    @IBAction func btnFacebook(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
           
            if !self.isVideo{
                facebookSheet.add(self.imageSel)
               
            }
            else{
                facebookSheet.add((self.videoURL! as URL))
                //facebookSheet.add
             
            }
            facebookSheet.setInitialText(txtVIewDetails.text)
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    ///Update on Twitter
    @IBAction func btnTwitter(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if !self.isVideo{
                twitterSheet.add(self.imageSel)
            }
            else{
                twitterSheet.add((self.videoURL! as URL))
            }
            twitterSheet.setInitialText(txtVIewDetails.text)
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    ///Update on Instagram
    @IBAction func btnInstagram(_ sender: UIButton) {
    }

}

extension SocialMediaVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        dismiss(animated: false, completion: nil)
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
         print("Got a video")
            videoURL = pickedVideo
            let player = AVPlayer(url: videoURL! as URL)
             playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x:0,y:0,width:100,height:81)
            imgView.isHidden = true
            imageSel = UIImage()
            self.viewImage.layer.addSublayer(playerLayer)
            
            player.pause()

            isVideo = true
        }
        else{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
             print("Got a images")
            playerLayer.removeFromSuperlayer()
             imgView.isHidden = false
            videoURL = NSURL()
            imageSel = chosenImage
            imgView.image = chosenImage
            isVideo = false
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        print("Canceled!!")
    }
    
}

extension SocialMediaVC:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVIewDetails.text == ""{
            txtVIewDetails.text = "write discription"
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVIewDetails.text == "write discription"{
            txtVIewDetails.text = ""
        }
    }
}
