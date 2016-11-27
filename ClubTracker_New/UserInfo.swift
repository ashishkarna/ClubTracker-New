//
//  UserInfo.swift
//  ClubTracker
//
//  Created by Ashish Karna on 11/27/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit

class UserInfo: NSObject , NSCoding {

    var user_id : String?
    var club_id : String?
    var first_name: String?
    var last_name: String?
    var avatar_link: String?
    var isTeacher: Bool?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        club_id = aDecoder.decodeObject(forKey: "club_id") as? String
        first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        avatar_link = aDecoder.decodeObject(forKey: "avatar_link") as? String
        isTeacher = aDecoder.decodeObject(forKey: "isTeacher") as? Bool
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(club_id, forKey: "club_id")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(avatar_link, forKey: "avatar_link")
        aCoder.encode(isTeacher, forKey: "isTeacher")

    }
}
