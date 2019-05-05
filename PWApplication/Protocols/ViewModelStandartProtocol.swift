//
//  ViewModelStandartProtocol.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation

protocol ViewModelStandartProtocol : class {
    func needShowAlert(_ text:String)
    func pushViewController<ParentViewController>(_ vc:ParentViewController)
    func refreshData()
}

//MARK: Optional methods
extension ViewModelStandartProtocol{
    func refreshData(){}
    func pushViewController<ParentViewController>(_ vc:ParentViewController){}
}
