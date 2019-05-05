//
//  ParentControllerWithBalance.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 03/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

open class ParentViewControllerWithBalance: ParentViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLbl: UILabel!
    
    // MARK: - Properties
    override open func viewDidLoad() {
        super.viewDidLoad()
        initUserInfoChangeNotification()
        setBalanceLbl()
    }
    
    func setBalanceLbl(){
        if let balance = AppManager.sharedInstance.currentUserInfo?.balance{
            balanceLbl.text = String(balance)
        }
    }
    
    func initUserInfoChangeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoChange), name: CustomNotification.userInfoChange.notification, object: nil)
    }
    
    @objc private func userInfoChange(){
        setBalanceLbl()
    }
    
    func refreshBalance(){
        
    }
}

