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



//MARK: Chat Member
class ChatMember{
    var id : String?
    var member_name: String?
    var name:String?
    var email: String?
    

}


//MARK: Chat List Detail
class ChatDetail{
    var id: String?
    var uuid: String?
    var created_by: String?
    var chat_name: String?
    var status: String?
    var unseen_chats: String?
    var last_message: String?
    var last_message_time: String?

}

class ChatsOfChat{
    var chat_id: String?
    var uuid : String?
    var member_id: String?
    var message: String?
    var uploads: String?
    var member_name: String?
    var avatar: String?
    
}


class DiaryModel{
    var identifier: String?
    var eventTitle : String?
    var eventDescritpion: String?
    var eventDate: String?
    var eventTime: String?
    var pickPoint: String?
    var createdAt: String?
    
}

//MARK: shop  item list
class ShopItemList{
    
    var id: Int?
    var item_title : String?
    var  price : Double?
    var image: String?
    var charge: Double?
    var available_options: String?
    
}

class shopItemDetails{
    var id: Int?
    var item_title : String?
    var  price : Double?
    var image: String?
    var charge: Double?
    var small: Int?
    var medium: Int?
    var large: Int?
    var available_options: String?
    var details: String?
}


