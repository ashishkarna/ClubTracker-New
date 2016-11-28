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
    
    
    fileprivate static func getHeaders() -> [String : String]? {
        
        var headers: [String : String]
        let auth = "Bearer " + (UserDefaults.standard.value(forKey: "userToken") as? String)!
        
        headers    = [
            "Authorization": auth
           
        ]
        return headers
        
    }
    

       fileprivate static func makeRequest(_ type: HTTPMethod, url: String, params: [String : AnyObject]?,header: [String : String]?, onCompletion: @escaping (DataResponse<Any>) -> ()) {
        //let paramters = try! NSJSONSerialization.JSONObjectWithData(params, options: [])

     //   Alamofire.request(url, method: .post,  parameters: params ?? nil, headers:header ?? nil,encoding: .JSON).responseJSON(completionHandler: onCompletion)
        Alamofire.request(url, method: type, parameters: params ?? nil, encoding: JSONEncoding.default, headers: header ?? nil).responseJSON(completionHandler: onCompletion)
    }

    

}

//MARK: Login

extension WebServiceHelper{

    static func login(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post,url: kLoginUserUrl,params: params,header: nil, onCompletion: onCompletion)
    }


    //GET USER DETAIL
    static func getUser(_ params: [String : AnyObject]?,onCompletion:@escaping(DataResponse<Any>)->()){
        
        self.makeRequest(.get, url:kAuthenticatedUserUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }

    
    static func logout(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.get,url: kLogoutUrl,params: nil,header: getHeaders(), onCompletion: onCompletion)
    }

}


//MARK: CLASS
extension WebServiceHelper{
    static func getAllClasses(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.get, url:kgetAllClassesUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }

}

//MARK: CHILD
extension WebServiceHelper{
    static func getAllChilds(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post, url:kgetAllChildsUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func saveChild(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        
        self.makeRequest(.post, url:ksaveChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func updateChild(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post, url:kupdateChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getChildAttendance(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post, url:kgetChildAttendanceUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    //MARK: GET
    
    
    
    
}

//MARK: diary
extension WebServiceHelper{
    static func getAllDiary(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post, url:kgetAllDiaryUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getAllDiaryDetail(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        self.makeRequest(.post, url:kGetDiaryDetailByIdentifierURL, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    //MARK: GET
    
    
    
    
}



//MARK: TEACHER MESSAGE
extension WebServiceHelper{
    
    static func saveMessage(_ params: [String : AnyObject]?,url: String,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url: url, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInboxCount(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kGetTeacherInboxCountUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInbox(_ params: [String : AnyObject]?,url: String,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:url, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    static func getTeacherOutbox(_ params: [String : AnyObject]?,url:String,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:url, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherInboxDetail(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url: kGetTeacherInboxDetailUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    static func getTeacherOutboxDetail(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kGetTeacherOutboxDetailUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getTeacherRequests(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:KGetTeacherRequestUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func completedAllPriorRequests(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kCompletedAllPriorRequestsUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    static func getParentList(_ params: [String : AnyObject]?,url: String ,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:url, params: params ,header: getHeaders(), onCompletion: onCompletion)
    }
    
}





//MARK: PARENT SECTION

extension WebServiceHelper{
    static func getMyChildren(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:kgetMyChildrenUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    
    //response
    static func getUrgentRequests(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetUrgentRequestsUrl, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    

}




//MARK: CHAT SECTION

extension WebServiceHelper{
    static func getChatLists(onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:kgetChatListsUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getChatsofChat(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetChatsofChatUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func sendChatMessage(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:ksendChatMessageUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    
}

//MARK: SHOP SECTION

extension WebServiceHelper{
    static func getAllShopItems(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:kGetAllShopItemURL, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    static func removeHopItem(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kRemoveShopItemURL, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getDetailShopItems(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetShopItemDetailURL, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func updateShopItems(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kUpdateShopItemURL, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func addShopItem(selectedImage:UIImage?, params: [String : AnyObject]?, onCompletion: @escaping (DataResponse<Any>) -> ()) {
        //let paramters = try! NSJSONSerialization.JSONObjectWithData(params, options: [])
        let image = selectedImage
        let imageData = UIImageJPEGRepresentation(image!, 0.6)! as Data
        let URL = try! URLRequest(url: kAddShopItemURL, method: .post, headers: getHeaders())
      //  let items = params!["itemdetails"] as! [String:AnyObject]
      //  let itm:[AnyObject] = items["item_options"] as! [AnyObject]
                Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", mimeType: "image/jpg")
             //  multipartFormData.append(dataExample , withName: "itemdetails")
//                let item = itm[0] as! [String:AnyObject]
                                for (key, value) in params! {
                                    if(key == "item_options"){
                                        let dataExample : Data = NSKeyedArchiver.archivedData(withRootObject: value) as Data
                                        multipartFormData.append(dataExample , withName: "item_options")
                                    
                                    }
                                    else{
                
                                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                   }
                  }
        },
            with: URL,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: onCompletion)
                    break
                default:
                    break
                    
                    
                }//switch
                
        }
        )
        
    }
    
    static func addItem(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        
        
        self.makeRequest(.post, url:kAddShopItemURL, params: params,header: getHeaders(), onCompletion: onCompletion)
}
}
