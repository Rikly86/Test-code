//
//  ParentTransactionViewModel.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 01/05/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation


class ParentViewModelWithMessenger: NSObject {
    
    //MARK: Properties
    internal var mess = Messenger(isDebug: true)
    weak var delegateStandart:ViewModelStandartProtocol?
    
    //MARK: Life cycle
    override init() {
        super.init()
        initMess()
    }
    
    //MARK: Private methods
    internal func initMess(){
        
    }
    
    //MARK: Public methods
    func isLoadingMessenger()->Bool{
        return mess.isLoading
    }
}

