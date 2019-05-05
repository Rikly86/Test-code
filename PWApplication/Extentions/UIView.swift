//
//  UIView.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func dropShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor(white: 0x000000, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}


