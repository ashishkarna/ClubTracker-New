//
//  Constants.swift
//  Albany
//
//  Created by Ebpearls on 10/08/2016.
//  Copyright © 2016 Ashwin. All rights reserved.
//
import UIKit

let kApplicationName = "Club Tracker"
let DomainName = "http://danieltestapp.co.uk/api/"
let appColor = UIColor(red: 171/255, green: 195/255, blue: 112/255, alpha: 1.0)

let lightAppColor = UIColor(red: 210/255, green: 240/255, blue: 139/255, alpha: 1.0)



let kTabBarHeight: CGFloat = 60
let kNavbarHeight: CGFloat = 70
let kExternalViewHeight = kTabBarHeight + kNavbarHeight
let kServerError = "Server Error"


//MARK: Login
let kLoginUserUrl = DomainName + "login"
let kAuthenticatedUserUrl = DomainName + "getAuthenticatedUser"

//MARK: CLASS
let kgetAllClassesUrl = DomainName + "getAllClasses"

//MARK: CHILD
let kgetAllChildsUrl = DomainName + "getClassChilds"
let ksaveChildAttendanceUrl = DomainName + "saveAttendance"
let kupdateChildAttendanceUrl = DomainName + "updateAttendance"
let kgetChildAttendanceUrl = DomainName + "getAttendance"


//MARK: TEACHER- MESSAGE
let kSaveMessageToParentUrl = DomainName + "saveMessage"
let kGetTeacherInboxCountUrl = DomainName + "getTeacherInboxCount"
let kGetTeacherInboxUrl = DomainName + "getTeacherInbox"
let kGetTeacherOutboxUrl = DomainName + "getTeacherOutbox"
let kGetTeacherInboxDetailUrl = DomainName + "getTeacherInboxDetail"
let kGetTeacherOutboxDetailUrl = DomainName + "getTeacherOutboxDetail"
let KGetTeacherRequestUrl = DomainName + "getTeacherRequests"
let kCompletedAllPriorRequestsUrl = DomainName + "completedAllPriorRequests"
let kGetParentListUrl = DomainName + "getParents"
