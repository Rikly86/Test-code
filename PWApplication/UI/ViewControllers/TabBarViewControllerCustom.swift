//
//  TabBarViewControllerCustom.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 28/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewControllerCustom:  UITabBarController{
    
    //TODO Make filter btn
    // MARK: - Life cicle
    class func controller() -> TabBarViewControllerCustom {
        return getController(String(describing: TabBarViewControllerCustom.self)) as! TabBarViewControllerCustom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initBarBtns()
    }
    
    // MARK: - Private methods
    func initBarBtns(){
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.leftBarButtonItem = logoutBtn
        navigationItem.rightBarButtonItem = getRefreshBtn()
    }
    
    fileprivate func getRefreshBtn()->UIBarButtonItem{
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Refresh"), style: .plain, target: self, action: #selector(refreshTapped(_:)))
    }
    
    fileprivate func getSortBtn()->UIBarButtonItem{
        return UIBarButtonItem(image: #imageLiteral(resourceName: "Sort"), style: .plain, target: self, action: #selector(sortTapped(_:)))
    }
    
    @objc func logoutTapped(){
        showAlertLogout()
    }
    
    @objc func sortTapped(_ sender:UIBarButtonItem){
        if selectedViewController is HistoryViewController {
            (selectedViewController as! HistoryViewController).sortTapped()
        }
    }
    
    @objc func refreshTapped(_ sender:UIBarButtonItem){
        (selectedViewController as! ParentViewControllerWithBalance).refreshBalance()
    }
    
    func showAlertLogout(){
        let alertView = UIAlertController(title: NSLocalizedString("Alert", comment: ""),
                                          message: NSLocalizedString("Do you really want to logout", comment: ""), preferredStyle:.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: okAlertLogoutTapped)
        alertView.addAction(okAction)
        let cancelBtn = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        alertView.addAction(cancelBtn)
        present(alertView, animated: true, completion: nil)
    }
    
    func okAlertLogoutTapped(alert: UIAlertAction!){
        RouteManager.sharedInstance.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewControllerCustom: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MyBalanceViewController {
           self.navigationItem.rightBarButtonItems = [self.getRefreshBtn()]
        }
        if viewController is HistoryViewController {
            self.navigationItem.rightBarButtonItems = [self.getRefreshBtn(),self.getSortBtn()]
        }
    }
}


