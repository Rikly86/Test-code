//
//  LoginViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import SVProgressHUD

class LoginViewModel: ParentViewModelWithMessenger{
    
    //MARK: Life cycle
    override init() {
        super.init()
        initMessenger()
    }
    
    //MARK: Private methods
    private func initMessenger(){
        mess.messResponseDelegate = self
    }
    
    //MARK: Public methods
    func sendLoginRequest(_ email:String,_ password:String){
        OperationQueue.main.addOperation {
            SVProgressHUD.show()
        }
        let dic: [String: String] = [
            "email":  email,
            "password": password
        ]
        mess.sendPostRequest(HttpParams.getHttpLogin(), type: HttpParams.LOGIN, postData: dic)
    }
}

//MARK: MessengerResponseDelegate
extension LoginViewModel : MessengerResponseDelegate {
    func errorResponse(_ error: String?, type: String) {
        DispatchQueue.main.async(execute: {
            //TODO
            OperationQueue.main.addOperation {
                SVProgressHUD.popActivity()
            }
            switch (type){
            case HttpParams.LOGIN:
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
            OperationQueue.main.addOperation {
                SVProgressHUD.popActivity()
            }
            switch (type){
            case HttpParams.LOGIN:
                AppManager.sharedInstance.token = ResponseParser.tokenParse(json)
                let vc = TabBarViewControllerCustom.controller()
                RouteManager.sharedInstance.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        })
    }
}

