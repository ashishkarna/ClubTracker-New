//
//  AutoComplete.swift
//  Waste Info Swift
//
//  Created by Developer8 on 7/28/16.
//  Copyright © 2016 Mohan. All rights reserved.
//

import UIKit

class AutoComplete: NSObject {
    //Mark: Declaration
   
    var pupilName : [String] = []
   // var suburbSuggestion = [String]()
    var pupilNameSuggestion = [String]()
    
    static let sharedInstance = AutoComplete()
    //MARK: Custom Function
    
    func pupilNameSuggestionFromPupilName(_ substring: String)->[String]
    {
        var childName = substring
        pupilNameSuggestion.removeAll(keepingCapacity: false)
       
        for curString in pupilName
        {
            childName = substring.replacingOccurrences(of: "%20", with: " ")
            if curString.capitalized.hasPrefix(childName.capitalized){
                pupilNameSuggestion.append(curString)
            }
        }
        if substring == ""{
            return pupilName
        }
        return pupilNameSuggestion
    }
 
    
   }
