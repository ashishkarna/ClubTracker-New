//
//  ChatViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/20/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        NSDictionary *parameters = @{
//            paramUserID : @"your_user_id",
//            paramName : @"your_user_name",
//            paramAvatarURL : @"http://url_to_your_avatar.jpg",
//            paramRoomID: @"Your_room_id"
//        };
        
        var params = [String :Sting]()
        params["paramUserId"] = "your_user_id"
        params["paramName"] = "username"
        params["paramRoomID"] = "room_id"
        
//        CSChatViewController *viewController = [[CSChatViewController alloc] initWithParameters:parameters];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//        [self presentViewController:navigationController animated:YES completion:nil];
        
        let vc = ChatViewController(params)
        let chatNav = UINavigationController(rootViewController: vc)
        self.present(chatNav, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
