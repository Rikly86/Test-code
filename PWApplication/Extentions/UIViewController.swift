//
//  UIViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func getController(_ cidRaw:String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let cid = cidRaw.components(separatedBy: ".").last else { fatalError() }
        return storyboard.instantiateViewController(withIdentifier: cid)
    }
}
