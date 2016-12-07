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
    
    static func getListOfPossibleChatMembers(_ params: [String : AnyObject]?,url: String ,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:url, params: params ,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func getChatLists(onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:kgetChatListsUrl, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getChatsofChat(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetChatsofChatUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    
    static func sendChatMessage(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:ksendChatMessageUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    
    static func createChat(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kcreateChatUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    
}



//MARK: TARGET SECTION
extension WebServiceHelper{

    
    //add target
    static func addTarget(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kaddTargetUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    //get target
    static func getTargets(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetTargetsUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    //get target of pupil
    
    static func getTargetOfPupil(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetTargetOfPupilUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    //get pupil of target
    static func getPupilOfTarget(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetPupilOfTargetUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    
    //change target status of child
    static func changeTargetStatusOfChild(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kchangeTargetStatusOfChildUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }


}


//MARK: DEVICE REGISTRATION
extension WebServiceHelper{
    static func addUpdateDeviceInfo(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kaddUpdateDeviceInfoUrl, params:params,header: getHeaders(), onCompletion: onCompletion)
    }

    

}


//MARK: SHOP SECTION

extension WebServiceHelper{
    static func getAllShopItems(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.get, url:kGetAllShopItemURL, params: nil,header: getHeaders(), onCompletion: onCompletion)
    }
    static func removeHopItem(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kRemoveShopItemURL, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func getDetailShopItems(_ params: [String : AnyObject]?,onCompletion:@escaping (DataResponse<Any>)->()){
        self.makeRequest(.post, url:kgetShopItemDetailURL, params: params,header: getHeaders(), onCompletion: onCompletion)
    }
    
    static func updateShopItem(selectedImage:UIImage?, params: [String : AnyObject]?, onCompletion: @escaping (DataResponse<Any>) -> ()) {
        let image = selectedImage
        let imageData = UIImageJPEGRepresentation(image!, 0.6)! as Data
        let URL = try! URLRequest(url: kUpdateShopItemURL, method: .post, headers: getHeaders())
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", mimeType: "image/jpg")
                
                for (key, value) in params! {
                    if(key == "options"){
                        let data  = value as! [[String:AnyObject]]
                        do{
                            let jsonData =  try JSONSerialization.data(withJSONObject: data, options:.prettyPrinted)
                            multipartFormData.append(jsonData , withName: "options")
                        }
                        catch let e as NSError{
                            print(e)
                        }
                    }
                    else{
                        
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                }
                print(multipartFormData)
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
    
    
    static func addShopItem(selectedImage:UIImage?, params: [String : AnyObject]?, onCompletion: @escaping (DataResponse<Any>) -> ()) {
        let image = selectedImage
        let imageData = UIImageJPEGRepresentation(image!, 0.6)! as Data
        let URL = try! URLRequest(url: kAddShopItemURL, method: .post, headers: getHeaders())
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", mimeType: "image/jpg")
                
                for (key, value) in params! {
                    if(key == "options"){
                        let data  = value as! [[String:AnyObject]]
                        do{
                            let jsonData =  try JSONSerialization.data(withJSONObject: data, options:.prettyPrinted)
                            multipartFormData.append(jsonData , withName: "options")
                        }
                        catch let e as NSError{
                            print(e)
                        }
                    }
                    else{
                        
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                }
                print(multipartFormData)
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

