//
//  RegistrationViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController: ParentViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var registrationBtn: UIButton!
    
    // MARK: - Properties
    fileprivate let viewModel = RegistrationViewModel()
    
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initMisk()
        initKeyboardNotification()
        initViewModel()
        initTestData()
    }
    
    // MARK: - Private methods
    private func initTestData(){
        email.text = "1@1.ru"
        name.text = "1"
        password.text = "1"
        passwordConfirm.text = "1"
    }
    
    private func initViewModel(){
        viewModel.delegateStandart = self
    }
    
    private func initMisk(){
        centralConstrainFirstPosition = -110
        
        registrationBtn.dropShadow()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.name {
            textField.resignFirstResponder()
            self.email.becomeFirstResponder()
        } else if textField == self.email {
            textField.resignFirstResponder()
            self.password.becomeFirstResponder()
        } else if textField == self.password {
            textField.resignFirstResponder()
            self.passwordConfirm.becomeFirstResponder()
        } else if textField == self.passwordConfirm {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Outlets methods
    @IBAction func regBtnTapped(_ sender: UIButton) {
        
        if viewModel.isLoadingMessenger() { return }
        view.endEditing(true)
        guard let name = self.name.text, !name.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill name", comment: ""))
            return
        }
        guard let email = self.email.text, !email.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill email", comment: ""))
            return
        }
        guard let password = self.password.text, !password.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill password", comment: ""))
            return
        }
        guard let passwordConfirm = self.passwordConfirm.text, !passwordConfirm.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill password confirm", comment: ""))
            return
        }
        if password == passwordConfirm{
            viewModel.sendRegistrationRequest(name, email, password)
        }else{
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Passwords do not match", comment: ""))
        }
    }
    
    @IBAction func clickOnCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewModelStandartProtocol
extension RegistrationViewController: ViewModelStandartProtocol{
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: text)
    }
    
    func pushViewController<ParentViewController>(_ vc: ParentViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}


