//
//  HistoryViewModel.swift
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

class HistoryViewModel: ParentViewModelWithMessenger {
    
    //MARK: Properties
    fileprivate var items = [HistoryModel]()
    fileprivate var filtredItems = [HistoryModel]()
    
    //MARK: Life cycle
    override init() {
        super.init()
        initMess()
    }
    
    //MARK: Private methods
    override internal func initMess(){
        mess.messResponseDelegate = self
        if let token = AppManager.sharedInstance.token{
            mess.bearerToken = token
        }
    }
    
    //MARK: Public methods
    func getHistory(){
        mess.sendGetRequest(HttpParams.getHttpUserTransactions(), type: HttpParams.USER_TRANSACTIONS)
    }
    
    func getBalance(){
        mess.sendGetRequest(HttpParams.getHttpUserInfo(), type: HttpParams.USER_INFO)
    }
}

//MARK: UITableViewDataSource
extension HistoryViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        cell.setData(self.filtredItems[indexPath.row],indexPath.row)
        cell.delegate = self
        return cell
    }
}

//MARK: UITableViewDelegate
extension HistoryViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK: MessengerResponseDelegate
extension HistoryViewModel : MessengerResponseDelegate {
    func errorResponse(_ error: String?, type: String) {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.popActivity()
            switch (type){
            case HttpParams.USER_INFO:
                break
            case HttpParams.USER_TRANSACTIONS:
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
            case HttpParams.USER_TRANSACTIONS:
                SVProgressHUD.popActivity()
                self.items = ResponseParser.userTransactionsParse(json)
                self.items.sort {
                    guard let value0 = $0.date, let value1 = $1.date else { return false }
                    return value0.timeIntervalSinceNow > value1.timeIntervalSinceNow
                }
                self.filtredItems = self.items
                self.delegateStandart?.refreshData()
                break
            default:
                break
            }
        })
    }
}

//MARK: HistoryTableViewCellProtocol
extension HistoryViewModel : HistoryTableViewCellProtocol {
    func repeatTransaction(_ index: Int) {
        let vc = RepeatTransactionViewController.controller()
        let currentUser = UserModel()
        currentUser.name = self.items[index].username
        vc.viewModel.setData(currentUser,  self.items[index].amount)
            RouteManager.sharedInstance.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: SortPopupViewModelProtocol
extension HistoryViewModel: SortPopupViewModelProtocol{
    func sortBy(_ value: SortPopupViewModel.SortType) {
        switch value {
        case .byName:
            self.filtredItems.sort {
                guard let value0 = $0.username, let value1 = $1.username else { return false }
                return value0 < value1
            }
        case .byDate:
            self.filtredItems.sort {
                guard let value0 = $0.date, let value1 = $1.date else { return false }
                return value0.timeIntervalSinceNow > value1.timeIntervalSinceNow
            }
        case .byAmount:
            self.filtredItems.sort {
                guard let value0 = $0.amount, let value1 = $1.amount else { return false }
                return value0 < value1
            }
        }
        
        self.delegateStandart?.refreshData()
    }
}

//MARK: UISearchBarDelegate
extension HistoryViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            self.filtredItems = self.items.filter {
                guard let value0 = $0.username else{return false}
                return value0.contains(searchText)
            }
        }else{
            self.filtredItems = self.items
        }
        self.delegateStandart?.refreshData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
