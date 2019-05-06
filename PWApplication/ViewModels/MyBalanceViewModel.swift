//
//  MyBalanceViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SwiftyJSON
import SVProgressHUD

class MyBalanceViewModel: ParentViewModelWithMessenger{
    
    //MARK: Properties
    internal var items = [UserModel]()
    
    //MARK: Life cycle
    override init() {
        super.init()
    }
    
    //MARK: Private methods
    override internal func initMess(){
        mess.messResponseDelegate = self
        if let token = AppManager.sharedInstance.token{
            mess.bearerToken = token
        }
    }
    
    internal func selectUser(_ item:UserModel){
        let vc = EnterTransactionViewController.controller()
        vc.viewModel.setData(item)
        RouteManager.sharedInstance.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Public methods
    func getBalance(){
        mess.sendGetRequest(HttpParams.getHttpUserInfo(), type: HttpParams.USER_INFO)
    }
    
    func getUsers(_ filterBy:String){
        SVProgressHUD.show()
        let dic: [String: String] = [
            "filter":  filterBy
            ]
            self.mess.sendPostRequest(HttpParams.getHttpUsersList(), type: HttpParams.USERS_LIST, postData:dic)
    }
}

//MARK: UITableViewDataSource
extension MyBalanceViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        cell.setData(self.items[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension MyBalanceViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectUser(self.items[indexPath.row])
    }
}

//MARK: MessengerResponseDelegate
extension MyBalanceViewModel : MessengerResponseDelegate {
    func errorResponse(_ error: String?, type: String) {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.popActivity()
            switch (type){
            case HttpParams.USER_INFO:
                break
            case HttpParams.USERS_LIST:
                break
            default:
                break
            }
        })
        
    }
    
    func callBackResponse(_ json: AnyObject, type: String) {
        DispatchQueue.main.async(execute: {
            switch (type){
            case HttpParams.USER_INFO:
                AppManager.sharedInstance.currentUserInfo = ResponseParser.userInfoParse(json)
                break
            case HttpParams.USERS_LIST:
                SVProgressHUD.popActivity()
                self.items = ResponseParser.usersListParse(json)
                self.delegateStandart?.refreshData()
                break
            default:
                break
            }
        })
    }
}

//MARK: UISearchBarDelegate
extension MyBalanceViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getUsers(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
