//
//  EnterTransactionViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 30/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class EnterTransactionViewController: ParentViewControllerWithBalance {
    
    // MARK: - Outlets
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: - Properties
    var viewModel:EnterTransactionViewModel = EnterTransactionViewModel()
    
    // MARK: - Life Cycle
    class func controller() -> EnterTransactionViewController {
        return getController(String(describing: EnterTransactionViewController.self)) as! EnterTransactionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationItems()
        initAccetoryView()
        initMisk()
        setData()
    }
    
    // MARK: - Private methods
    private func initAccetoryView(){
        let toolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.barStyle = UIBarStyle.default
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let nextButton: UIBarButtonItem =  UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        toolBar.items = [flexsibleSpace, nextButton]
        self.amountTextField.inputAccessoryView = toolBar
    }
    
    private func initNavigationItems(){
        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextBtn
    }
    
    private func initMisk(){
        amountTextField.becomeFirstResponder()
    }
    
    private func setData(){
        title = viewModel.item?.name
        if let amount = viewModel.amount{
            self.amountTextField.text = String(abs(amount))
        }
    }
    
    @objc func nextTapped(){
        guard let amountStr = amountTextField.text, !amountStr.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill amount", comment: ""))
            return
        }
        if viewModel.checkAmount(amountStr){
            let vc = viewModel.getSendTransactionVC()
            vc.viewModel.amount = Int(amountStr)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Not enough funds on balance", comment: ""))
        }
        
    }
}
