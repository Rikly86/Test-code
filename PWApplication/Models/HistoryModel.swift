//
//  HistoryModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 29/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import ObjectMapper

class HistoryModel: NSObject, Mappable {

    // MARK: - Properties
    var id: String!
    var dateStr: String?
    var username: String?
    var amount: Int?
    var balance: Int?
    var date: Date?
    
    // MARK: - Life cicle
    required init?(map: Map) {
        super.init()
    }
    
    override init(){
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        dateStr <- map["date"]
        username <- map["username"]
        amount <- map["amount"]
        balance <- map["balance"]
        if let dateStr = self.dateStr{
            date = Date.stringToDateYYYYMMDD(dateStr)
        }
    }
    
    
}
