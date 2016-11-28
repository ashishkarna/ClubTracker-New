//
//  PlayerViewController.swift
//  CameraTestByMohan
//
//  Created by Mohan Singh Thagunna on 11/20/16.
//  Copyright © 2016 CreatuDevelopers. All rights reserved.
//

import AVKit
import UIKit
import AVFoundation
import Social

class PlayerViewController: UIViewController {
    var isVideo = true
    var videoURL:NSURL?
    var imageSel = UIImage()
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var viewVideo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if isVideo{
            viewVideo.isHidden = false
        let player = AVPlayer(url: videoURL! as URL)
        let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x:0,y:0,width:self.viewVideo.frame.size.width,height:self.viewVideo.frame.size.height)
        self.viewVideo.layer.addSublayer(playerLayer)
        player.play()
        }
        else{
            viewVideo.isHidden = true
            img.image = imageSel
            
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnShare(_ sender: Any) {
 
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Share", message: "Share with facebook or twitter", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // blue action button
        let fbAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default) { (action) in
            print("fb action button tapped")
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("Share on Facebook")
                if !self.isVideo{
                    facebookSheet.add(self.imageSel)
                }
                else{
                    facebookSheet.add((self.videoURL! as URL))
                    //facebookSheet.add
                }
                facebookSheet.setInitialText("Share on facebook")
                self.present(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // red action button
        let ttAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default) { (action) in
            print("twitter action button tapped")
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                if !self.isVideo{
                twitterSheet.add(self.imageSel)
                }
                else{
                twitterSheet.add((self.videoURL! as URL))
                }
                twitterSheet.setInitialText("Share on Twitter")
                self.present(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        // red action button
        let cAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print("cancel action button tapped")
        }
        
        
        // add action buttons to action sheet
        myActionSheet.addAction(fbAction)
        myActionSheet.addAction(ttAction)
          myActionSheet.addAction(cAction)
      
        
//        // support iPads (popover view)
//        myActionSheet.popoverPresentationController?.sourceView = self.showActionSheetButton
//        myActionSheet.popoverPresentationController?.sourceRect = self.showActionSheetButton.bounds
//        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }

}
