//
//  ResponseParser.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

struct ResponseParser {
    
    static func tokenParse(_ json:AnyObject)->String{
        let jsonData = JSON(json)
        return jsonData["id_token"].stringValue
    }
    
    static func userInfoParse(_ json:AnyObject)->UserModel?{
        let jsonData = JSON(json)
        let userInfo = jsonData["user_info_token"]
        let user = Mapper<UserModel>().map(JSONObject: userInfo.dictionaryObject)
        return user
    }
    
    static func usersListParse(_ json:AnyObject)->[UserModel]{
        var result = [UserModel]()
        let jsonData = JSON(json)
        guard let usersDic = jsonData.array else {return result}
        for item in usersDic {
            if let user = Mapper<UserModel>().map(JSONObject: item.object){
                result.append(user)
            }
        }
        
        return result
    }
    
    static func userTransactionsParse(_ json:AnyObject)->[HistoryModel]{
        var result = [HistoryModel]()
        let jsonData = JSON(json)
        guard let transDic = jsonData["trans_token"].array else {return result}
        for item in transDic {
            if let transaction = Mapper<HistoryModel>().map(JSONObject: item.object){
                result.append(transaction)
            }
        }
        return result
    }
}
