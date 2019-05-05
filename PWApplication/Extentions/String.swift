//
//  String.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 27/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

extension String{
    func isEmptyOrWhitespace() -> Bool {
        if(isEmpty) {
            return true
        }
        
        return (self.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }
}
