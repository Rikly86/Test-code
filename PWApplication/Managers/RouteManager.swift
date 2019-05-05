//
//  RouteManager.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 02/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//


import Foundation
import UIKit

class RouteManager {
    
    static let sharedInstance = RouteManager()
    
    var navigationController:UINavigationController?
    
    func launch(with window: UIWindow?) {
        if let nc = window?.rootViewController as? UINavigationController{
            navigationController = nc
        }
    }
    
    func popToViewController(_ vc:AnyClass) {
        guard let navViewController = navigationController else{ fatalError() }
        for viewController in navViewController.viewControllers {
            if(viewController.isKind(of: vc) ) {
                navViewController.popToViewController(viewController, animated: true)
            }
        }
    }
}






