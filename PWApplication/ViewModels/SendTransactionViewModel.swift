//
//  SendTransactionViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//


import Foundation
import SVProgressHUD

class SendTransactionViewModel: ParentViewModelWithMessenger{
    
    //MARK: Properties
    var amount:Int?
    var item:UserModel?
    
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
    
    //MARK: Public methods
    func getBalance(){
        mess.sendGetRequest(HttpParams.getHttpUserInfo(), type: HttpParams.USER_INFO)
    }
    
    func sendTransaction(_ name:String,_ amount:Int){
        OperationQueue.main.addOperation{
            SVProgressHUD.show()
            let dic: [String: Any] = [
                "name":  name,
                "amount":  amount
            ]
            self.mess.sendPostRequest(HttpParams.getHttpUserTransactions(), type: HttpParams.USER_NEW_TRANSACTION, postData:dic)
        }
    }
    
    func setData(_ item:UserModel?, _ amount:Int? = nil){
        self.item = item
        self.amount = amount
    }
    
}

//MARK: MessengerResponseDelegate
extension SendTransactionViewModel : MessengerResponseDelegate {
    func errorResponse(_ error: String?, type: String) {
        DispatchQueue.main.async(execute: {
            //TODO
            OperationQueue.main.addOperation {
                SVProgressHUD.popActivity()
            }
            switch (type){
            case HttpParams.USER_INFO:
                break
            case HttpParams.USER_NEW_TRANSACTION:
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
                OperationQueue.main.addOperation {
                    SVProgressHUD.popActivity()
                }
                self.delegateStandart?.refreshData()
                break
            case HttpParams.USER_NEW_TRANSACTION:
                self.getBalance()
                break
            default:
                break
            }
        })
    }
}


