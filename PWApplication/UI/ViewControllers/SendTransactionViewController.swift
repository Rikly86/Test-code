//
//  SendTransactionViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

//protocol SendTransactionPopupViewControllerDelegate : class {
//    func openRegistration()
//}

class SendTransactionViewController: ParentViewControllerWithBalance {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var sendAmountLbl: UILabel!
    @IBOutlet weak var balanceAfterTransactionLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    // MARK: - Properties
    var viewModel:SendTransactionViewModel = SendTransactionViewModel()
    
    // MARK: - Life Cycle
    class func controller() -> SendTransactionViewController {
        return getController(String(describing: SendTransactionViewController.self)) as! SendTransactionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        initViewModel()
    }
    
    // MARK: - Private methods
    private func initViewModel(){
        viewModel.delegateStandart = self
    }
    
    private func setData(){
        nameLbl.text = viewModel.item?.name
        if let amount = viewModel.amount{
            sendAmountLbl.text = String(amount)
            sendBtn.setTitle("Send \(amount)", for: .normal)
        }
    }
    
    override func setBalanceLbl() {
        super.setBalanceLbl()
        if let balance = AppManager.sharedInstance.currentUserInfo?.balance, let amount = viewModel.amount{
            balanceAfterTransactionLbl.text = String( balance - amount)
        }
    }
    
    // MARK: - Outlets methods
    @IBAction func sendTapped(_ sender: Any) {
        viewModel.sendTransaction(viewModel.item!.name!, viewModel.amount!)
    }
}

// MARK: - ViewModelStandartProtocol
extension SendTransactionViewController: ViewModelStandartProtocol{
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: text)
    }
    
    func refreshData() {
        RouteManager.sharedInstance.popToViewController(TabBarViewControllerCustom.self)
    }
}
