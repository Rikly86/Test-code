//
//  RepeatTransacrionViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 03/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

protocol RepeatTransacrionViewModelProtocol : class {
    func selectUser(_ item:UserModel)
}

class RepeatTransacrionViewModel: MyBalanceViewModel {
    
    //MARK: Properties
    var amount:Int?
    var item:UserModel?
    
    weak var delegateCustom:RepeatTransacrionViewModelProtocol?
    
    //MARK: Private methods
    override func selectUser(_ item: UserModel) {
        self.item = item
        delegateCustom?.selectUser(item)
    }
    
    //MARK: Public methods
    func showEnterTransaction(){
        let vc = EnterTransactionViewController.controller()
        vc.viewModel.setData(item, amount)
        RouteManager.sharedInstance.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData(_ item:UserModel?, _ amount:Int? = nil){
        self.item = item
        self.amount = amount
    }
}


