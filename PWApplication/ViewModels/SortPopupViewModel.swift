//
//  SortPopupViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 05/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//


import Foundation
import UIKit
import ObjectMapper
import SwiftyJSON
import SVProgressHUD

protocol SortPopupViewModelProtocol : class {
    func sortBy(_ value:SortPopupViewModel.SortType)
}

class SortPopupViewModel: NSObject {
    
    //MARK: Properties
    internal var items = ["Name","Date","Amount"]
    weak var delegate:SortPopupViewModelProtocol?
    weak var delegateForDismiss:SortPopupViewModelProtocol?
    
    enum SortType:Int{
        case byName = 0
        case byDate = 1
        case byAmount = 2
    }
    
    //MARK: Life cycle
    override init() {
        super.init()
    }
}

// MARK: - UITableViewDataSource
extension SortPopupViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell") as! SortTableViewCell
        cell.setData(self.items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SortPopupViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sort = SortPopupViewModel.SortType(rawValue: indexPath.row){
            self.delegate?.sortBy(sort)
            self.delegateForDismiss?.sortBy(sort)
        }
    }
}

