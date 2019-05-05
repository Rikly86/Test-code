//
//  AppManager.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

class AppManager {
    
    static let sharedInstance = AppManager()
    
    public var token:String?
    public var currentUserInfo:UserModel?{
        didSet {
            NotificationCenter.default.post(name: CustomNotification.userInfoChange.notification, object: nil)
        }
    }
}

enum CustomNotification : String {
    
    case userInfoChange = "UserInfoChange"
    
    var notification : Notification.Name  {
        return Notification.Name(rawValue: self.rawValue )
    }
}





