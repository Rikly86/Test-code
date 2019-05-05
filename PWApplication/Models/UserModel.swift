//
//  UserModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 29/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: NSObject, Mappable {
    
    // MARK: - Properties
    var id: Int!
    var name: String?
    var email: String?
    var balance: Int?
    
    // MARK: - Life cicle
    required init?(map: Map) {
        super.init()
    }
    
    override init(){
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        balance <- map["balance"]
    }
}
