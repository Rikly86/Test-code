//
//  Date.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 03/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

extension Date{
    
    static func stringToDateYYYYMMDD(_ value:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let date = dateFormatter.date(from: value) else {
            return nil
        }
        return date
    }
    
}
