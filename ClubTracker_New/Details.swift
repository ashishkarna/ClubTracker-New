//
//  Details.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/19/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import Foundation

//MARK: Class
class Class{
    
    var id: Int?
    var name: String?
    var clubId: String?
    
}

//MARK: Child
class Child{

    var id: Int?
    var class_id: String?
    var club_id: String?
    var section_id: String?
    var parent_id: String?
    var firstName: String?
    var lastName: String?
    var status: String?
    var class_name: String?
    
//    var gender: String?
//    var date_of_birth : String?
//    var join_date: String?
//    var avatar: String?
//    var passout_date: String?
//    var email: String?
//    var address: String?
//    var latitude: String?
//    var longitude: String?
    
    
    
}

//MARK: Teacher
class Teacher{
    var id: Int?
    var name: String?
    var email: String?
    var teacher_fullname: String?
    var avatar: String?
    var gender: String?
    var date_of_birth: String?

}

//MARK: Parent
class Parent{
    var id: Int?
    var name: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    var avatarLink: String?

}

//MARK: Outbox
class Outbox{
    var identifier: String?
    var club_id : String?
    var  class_id : String?
    var subject: String?
    var message: String?
    var is_urgent: String?
    var deadline: String?
    var cost: String?
    var event_date: String?
    var pickup_point: String?
    var reminder: String?
    var message_to: String?
    var created_at: String?

}

//MARK: Inbox
class Inbox{
    var id: Int?
    var identifier: String?
    var club_id: String?
    var class_id: String?
    var message_to: String?
    var subject: String?
    var message: String?
    var watched: String?
    var reminder: String?
    var message_from: String?
    var from_name: String?
    var created_at: String?

}


//MARK: Urgent Request
class UrgentRequest{

    var identifier: String?
    var club_id : String?
    var  class_id : String?
    var subject: String?
    var message: String?
    var is_urgent: String?
    var deadline: String?
    var cost: String?
    var event_date: String?
    var pickup_point: String?
    var event_time: String?
    var reminder: String?
    var message_to: String?
    var created_at: String?
    var responded_percent: Int?


}


