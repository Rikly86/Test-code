//
//  HttpParams.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

struct HttpParams {
    static let REGISTRATION = "registration"
    static let LOGIN = "login"
    static let USER_TRANSACTIONS = "userTransactions"
    static let USER_INFO = "userInfo"
    static let USERS_LIST = "usersList"
    static let USER_NEW_TRANSACTION = "userNewTransaction"
    
    
    static let BASE_URL_DEV = "http://193.124.114.46:3001"
    static let BASE_URL_PRODUCTION = "http://193.124.114.46:3001"
    
    static var url:String = BASE_URL_DEV
    
    static let testLogin = "1@1.ru"
    static let testPassword = "1"
    
    //POST request
    static func getHttpCreateUser()->String{
        return "\(url)/users"
    }
    
    //POST request
    static func getHttpLogin()->String{
        return "\(url)/sessions/create"
    }
    
    //GET/POST request
    static func getHttpUserTransactions()->String{
        return "\(url)/api/protected/transactions"
    }
    
    //GET request
    static func getHttpUserInfo()->String{
        return "\(url)/api/protected/user-info"
    }
    
    //POST request
    static func getHttpUsersList()->String{
        return "\(url)/api/protected/users/list"
    }
}
