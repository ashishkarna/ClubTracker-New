//
//  WebServiceHelper.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/19/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceHelper: NSObject {
    
    
    private static func getHeaders() -> [String : String]? {
        
        var headers: [String : String]
        let auth = "Bearer " + (NSUserDefaults.standardUserDefaults().valueForKey("userToken") as? String)!
        
        headers    = [
            "Authorization": auth
           
        ]
        return headers
        
    }
    

       private static func makeRequest(type: Alamofire.Method, url: String, params: [String : AnyObject]?,header: [String : String]?, onCompletion: (Response<AnyObject, NSError>) -> ()) {
        //let paramters = try! NSJSONSerialization.JSONObjectWithData(params, options: [])

        Alamofire.request(type, url, parameters: params ?? nil, headers:header ?? nil,encoding: .JSON).responseJSON(completionHandler: onCompletion)
        
    }

    

}

//MARK: Login

extension WebServiceHelper{

    static func login(params: [String : String]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.POST, url:kLoginUserUrl, params: params,header: nil, onCompletion: onCompletion)
    }


    //GET USER DETAIL
    static func getUser(params: [String : String]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.GET, url:kAuthenticatedUserUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }


}


//MARK: CLASS
extension WebServiceHelper{
    static func getAllClasses(params: [String : String]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.GET, url:kgetAllClassesUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }

}

//MARK: CHILD
extension WebServiceHelper{
    static func getAllChilds(params: [String : String]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.POST, url:kgetAllChildsUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func saveChild(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        
        self.makeRequest(.POST, url:ksaveChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func updateChild(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.POST, url:kupdateChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getChildAttendance(params: [String : String]?,onCompletion:(Response<AnyObject,NSError>)->()){
        
        self.makeRequest(.POST, url:kgetChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    //MARK: GET
    
    
    
    
}




//MARK: TEACHER MESSAGE
extension WebServiceHelper{
    
    static func saveMessage(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url: kSaveMessageToParentUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInboxCount(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kGetTeacherInboxCountUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInbox(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kGetTeacherInboxUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    static func getTeacherOutbox(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kGetTeacherOutboxUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInboxDetail(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url: kGetTeacherInboxDetailUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    static func getTeacherOutboxDetail(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kGetTeacherOutboxDetailUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherRequests(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:KGetTeacherRequestUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func completedAllPriorRequests(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kCompletedAllPriorRequestsUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    static func getParentList(params: [String : AnyObject]?,onCompletion:(Response<AnyObject,NSError>)->()){
        self.makeRequest(.POST, url:kGetParentListUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
}