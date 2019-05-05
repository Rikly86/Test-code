//
//  LoginViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:  ParentViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var logoWidthConstrain: NSLayoutConstraint!
    
    // MARK: - Properties
    fileprivate let viewModel = LoginViewModel()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        initTestData()
        initMisc()
        initKeyboardNotification()
        animateLogo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private methods
    private func initMisc(){
        centralConstrainFirstPosition = 150
        loginBtn.dropShadow()
        registrationBtn.dropShadow()
    }
    
    private func initViewModel(){
        viewModel.delegateStandart = self
    }
    
    private func initTestData(){
        email.text = "1@1.ru"
        password.text = "1"
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.email {
            textField.resignFirstResponder()
            self.password.becomeFirstResponder()
        } else if textField == self.password {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func animateLogo(){
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseInOut, animations: {
            self.logoWidthConstrain.constant = 260
            self.logoImg.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Outlets methods
    @IBAction func loginTapped(_ sender: UIButton) {
        if viewModel.isLoadingMessenger() {return}
        view.endEditing(true)
        guard let email = self.email.text, !email.isEmptyOrWhitespace() else {
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill Email", comment: ""))
            return
        }
        guard let password = self.password.text, !password.isEmptyOrWhitespace() else{
            self.showAlert(NSLocalizedString("Alert", comment: ""), messegeText: NSLocalizedString("Please fill password", comment: ""))
            return
        }
        
        viewModel.sendLoginRequest(email, password)
    }
}

// MARK: - ViewModelStandartProtocol
extension LoginViewController: ViewModelStandartProtocol{
    func needShowAlert(_ text: String) {
        self.showAlert(NSLocalizedString("ALERT", comment: ""), messegeText: text)
    }
}


