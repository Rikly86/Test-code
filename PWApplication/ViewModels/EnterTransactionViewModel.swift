//
//  EnterTransactionViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

class EnterTransactionViewModel: NSObject {
    
    //MARK: Properties
    var amount:Int?
    var item:UserModel?
    
    //MARK: Life cycle
    override init() {
        super.init()
    }
    
    //MARK: Public methods
    func setData(_ item:UserModel?, _ amount:Int? = nil){
        self.item = item
        self.amount = amount
    }
    
    func getSendTransactionVC()->SendTransactionViewController{
        let vc = SendTransactionViewController.controller()
        vc.viewModel.item = self.item
        vc.viewModel.amount = self.amount
        return vc
    }
    
    func checkAmount(_ enteredAmount:String)->Bool{
        guard let balance = AppManager.sharedInstance.currentUserInfo?.balance, let amount = Int(enteredAmount) else {
            return false
        }
        return amount < balance
    }
}

