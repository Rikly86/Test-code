//
//  RegistrationViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import SVProgressHUD

class RegistrationViewModel: ParentViewModelWithMessenger {
    
    //MARK: Life cycle
    override init() {
        super.init()
    }
    
    //MARK: Private methods
    override internal func initMess(){
        mess.messResponseDelegate = self
    }
    
    //MARK: Public methods
    func sendRegistrationRequest(_ name:String,_ email:String,_ password:String){
        OperationQueue.main.addOperation {
            SVProgressHUD.show()
        }
        let dic: [String: String] = [
            "username": name,
            "password": password,
            "email":  email
        ]
        mess.sendPostRequest(HttpParams.getHttpCreateUser(), type: HttpParams.REGISTRATION, postData: dic)
    }
    
    //MARK: Public methods
    func getBalance(){
        mess.sendGetRequest(HttpParams.getHttpUserInfo(), type: HttpParams.USER_INFO)
    }
}

//MARK: MessengerResponseDelegate
extension RegistrationViewModel : MessengerResponseDelegate {
    func errorResponse(_ error: String?, type: String) {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.popActivity()
            switch (type){
            case HttpParams.REGISTRATION:
                if let err = error{
                    self.delegateStandart?.needShowAlert(err)
                }
                break
            default:
                break
            }
        })
        
    }
    
    func callBackResponse(_ json: AnyObject, type: String) {
        DispatchQueue.main.async(execute: {
            switch (type){
            case HttpParams.REGISTRATION:
                AppManager.sharedInstance.token = ResponseParser.tokenParse(json)
                if let token = AppManager.sharedInstance.token{
                    self.mess.bearerToken = token
                }
                self.getBalance()
                break
            case HttpParams.USER_INFO:
                SVProgressHUD.popActivity()
                AppManager.sharedInstance.currentUserInfo = ResponseParser.userInfoParse(json)
                let vc = TabBarViewControllerCustom.controller()
                self.delegateStandart?.pushViewController(vc)
                RouteManager.sharedInstance.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        })
    }
}

