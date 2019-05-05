//
//  Messenger.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

protocol MessengerResponseDelegate {
    func callBackResponse(_ json: AnyObject,type:String)
    func errorResponse(_ error: String?,type:String)
}

class Messenger {
    
    let STATUS_SUCCESS = "statusSuccess"
    let STATUS_REQUEST_ERROR = "statusRequestError"
    let STATUS_SERVER_ERROR = "statusServerError"
    
    fileprivate var isDebug: Bool
    
    var isLoading: Bool = false
    var bearerToken:String?
    
    var messResponseDelegate: MessengerResponseDelegate?
    
    init(isDebug:Bool = false) {
        self.isDebug = isDebug
    }
    
    fileprivate func createRequest(_ reqMethod:String,urlString:String)-> NSMutableURLRequest{
        if self.isDebug{
            print("\(reqMethod) Request to: \(urlString)")
        }
        
        let nsUrl = URL(string:urlString)!
        let req = NSMutableURLRequest(url: nsUrl)
        req.httpMethod = reqMethod
        req.timeoutInterval = 20
        
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = bearerToken{
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }
    
    func sendGetRequest(_ urlString : String,type:String){
        self.sendRequest(self.createRequest("GET", urlString: urlString),type: type)
    }
    
    func sendDeleteRequest(_ urlString : String,type:String){
        self.sendRequest(self.createRequest("DELETE", urlString: urlString),type: type)
    }
    
    func sendPatchRequest(_ urlString : String,type:String){
        self.sendRequest(self.createRequest("PATCH", urlString: urlString),type: type)
    }
    
    func sendPostRequest(_ urlString : String,type:String,postData:Dictionary<String,Any>){
        let req = self.createRequest("POST", urlString: urlString)
        
        do {
            try req.httpBody = JSONSerialization.data(withJSONObject: postData, options:[])
        } catch {
            print("Json to NSData parse error with messege: \(error)")
        }
        
        self.sendRequest(req, type: type)
    }
    
    func sendPutRequest(_ urlString : String,type:String,postData:NSDictionary){
        let req = self.createRequest("PUT", urlString: urlString)
        
        req.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        do {
            try req.httpBody = JSONSerialization.data(withJSONObject: postData, options:[])
        } catch {
            print("Json to NSData parse error with messege: \(error)")
        }
        
        self.sendRequest(req, type: type)
    }
    
    fileprivate func getHttpStatusCode(_ statusRaw:Int)->HTTPStatusCode{
        var result:HTTPStatusCode = .badRequest
        if statusRaw > 199 && statusRaw < 300{
            result = .ok
        }
        if statusRaw > 399 && statusRaw < 500{
            result = .badRequest
        }
        if statusRaw > 499 && statusRaw < 600{
            result = .internalServerError
        }
        return result
    }
    
    fileprivate func sendRequest(_ req:NSMutableURLRequest,type:String){
        let start = Date();
        
        self.isLoading = true
        let task = URLSession.shared.dataTask(with: req as URLRequest) {data,response,error in
            self.isLoading = false
            
            if let httpResponse = response as? HTTPURLResponse {
                let end = Date();
                let timeInterval: Double = end.timeIntervalSince(start);
                
                if self.isDebug{
                    print("Response from: \(String(describing: req.url)),HTTP status: \(httpResponse.statusCode), Time: \(timeInterval) seconds, Error \(String(describing: error))")
                }
                
                let httpStatus:HTTPStatusCode = self.getHttpStatusCode(httpResponse.statusCode)
                
                switch (httpStatus) {
                case .ok:
                    guard let d:Data = data, let _:URLResponse = response, error == nil else {
                    self.messResponseDelegate?.errorResponse(nil,type: type)
                        if self.isDebug{
                            print("Request error")
                        }
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                        self.messResponseDelegate?.callBackResponse(json as AnyObject, type:type)
                    } catch {
                        self.messResponseDelegate?.errorResponse(nil,type: type)
                        
                        if self.isDebug{
                            print("Error serializing JSON: \(error)")
                        }
                    }
                    break
                case .badRequest:
                    var error = ""
                    if let d = data{
                        error = String(decoding: d, as: UTF8.self)
                    }
                    self.messResponseDelegate?.errorResponse(error,type: type)
                    if self.isDebug{
                        print(error)
                    }
                case .internalServerError:
                    self.messResponseDelegate?.errorResponse(nil,type: type)
                    if self.isDebug{
                        print("Server error")
                    }
                    break
                default:
                    self.messResponseDelegate?.errorResponse(nil,type: type)
                    if self.isDebug{
                        print("Undefined status of response")
                    }
                    break
                }
            }else{
                self.messResponseDelegate?.errorResponse(nil,type: type)
                if self.isDebug{
                    print("Undefined status of response")
                }
            }
        }
        task.resume()
    }
}



enum HTTPStatusCode: Int {
    // 100 Informational
    case `continue` = 100
    case switchingProtocols
    case processing
    // 200 Success
    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case iMUsed = 226
    // 300 Redirection
    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permanentRedirect
    // 400 Client Error
    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest = 421
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    // 500 Server Error
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended = 510
    case networkAuthenticationRequired
}
