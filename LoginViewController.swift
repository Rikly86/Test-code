//
//  LoginViewController.swift
//
//  Created by Mac on 06.11.2018.
//
// (╯°□°）╯︵ ┻━┻

import Foundation
import UIKit
import FirebaseAuth
import Localize_Swift
import Firebase

class LoginViewController: ParentFirebaseDbViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var requestSupportBtn: UIButton!
    @IBOutlet weak var forgotPass: UIButton!
    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var noLoginBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var bottomBgConstrain: NSLayoutConstraint!
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var tableViewTopSpaceConstrain: NSLayoutConstraint!
    @IBOutlet weak var requestSupportBtnConstrain: NSLayoutConstraint!
    
    // MARK: - Properties
    fileprivate var currentEmailFieldConstrainValue = 0.0
    
    fileprivate var firstGroupContent = ["contact","checklist","goldenRules", "account","changeLanguage"]
    fileprivate var items = [String]()
    
    fileprivate var isLoginBtn:Bool = true
    fileprivate var isLoading:Bool = false
    
    fileprivate var selectedDynamicPage:MappedDynamicPages?
    fileprivate var dynamicPages = [MappedDynamicPages]()
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMisk()
        self.initNotifications()
        self.checkIfUserIsSignedIn()
        self.initShadows()
    }
    
    private func initNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(signIn), name: CustomNotification.login.notification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: CustomNotification.logout.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLang), name: CustomNotification.changeLang.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRegister), name: CustomNotification.register.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func initShadows(){
        self.dropShadow(view: self.logoImg)
        self.dropShadow(view: self.loginBtn)
        self.dropShadow(view: self.noLoginBtn)
        self.dropShadow(view: self.registrationBtn)
        self.dropShadow(view: self.requestSupportBtn)
    }
    
    private func initMisk(){
        self.items = self.firstGroupContent
        self.setGradient(0.5)
    }
    
    private func setGradient(_ endPoinY:Double){
        let gradientMaskLayer:CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bg.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientMaskLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientMaskLayer.endPoint = CGPoint (x: 0, y: endPoinY)
        self.bg.layer.mask = gradientMaskLayer
    }
    
    deinit {
        ref.child("dynamicPages").child(Localize.currentLanguage()).removeObserver(withHandle: databaseHandle)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Private methods
    fileprivate func checkIfUserIsSignedIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                if user!.isEmailVerified{
                    self.signIn()
                }
            } 
        }
    }

    @objc fileprivate func showRegister(){
        self.performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    
    @objc fileprivate func changeLang(){
        ref.child("dynamicPages").child(Localize.currentLanguage()).removeObserver(withHandle: databaseHandle)
        self.startObservingDatabase()
    }
    
    fileprivate func setMenuItems(){
        self.items = self.firstGroupContent
        for _ in self.dynamicPages{
            self.items.append("dynamicPage")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Override methods
    override func startObservingDatabase () {
        databaseHandle = ref.child("dynamicPages").child(Localize.currentLanguage()).observe(.value, with: { (snapshot) in
            self.dynamicPages = [MappedDynamicPages]()
            for itemSnapShot in snapshot.children {
                self.dynamicPages.append(MappedDynamicPages(snapshot: itemSnapShot as! DataSnapshot))
            }
            self.setMenuItems()
        })
        
    }
    
    override func setText(){
        self.email.placeholder = "EMAIL".localized()
        self.password.placeholder = "PASSWORD".localized()
        self.requestSupportBtn.setTitle("LOGIN_REQUEST_SUPPORT".localized(), for: .normal)
        self.registrationBtn.setTitle("REGISTRATION_BUTTON_NAME".localized(), for: .normal)
        self.noLoginBtn.setTitle("LOGIN_SKIP_BTN".localized(), for: .normal)
        self.forgotPass.setTitle("LOGIN_FORGOT_PASS".localized(), for: .normal)
        self.loginBtn.setTitle("LOGIN".localized(), for: .normal)
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier ==  "showDynamicPages"{
            let vc = segue.destination as! DynamicPageViewController
            vc.config = self.selectedDynamicPage
        }
    }
    
    //MARK: Login/Logout methods
    @objc fileprivate func signIn(){
        UIView.animate(withDuration: 0.5) {
            self.emailView.alpha = 0
            self.passwordView.alpha = 0
            self.registrationBtn.alpha = 0
            self.noLoginBtn.alpha = 0
            self.loginBtn.alpha = 0
            
            self.emailView.isUserInteractionEnabled = false
            self.passwordView.isUserInteractionEnabled = false
            self.registrationBtn.isUserInteractionEnabled = false
            self.noLoginBtn.isUserInteractionEnabled = false
            self.loginBtn.isUserInteractionEnabled = false
            
            self.requestSupportBtn.alpha = 1
            self.requestSupportBtn.isUserInteractionEnabled = true
            self.tableView.alpha = 1
            self.bottomBgConstrain.constant = self.view.bounds.height - 200
            self.requestSupportBtnConstrain.constant = 30
            self.tableViewTopSpaceConstrain.constant = 200
            
            self.view.layoutIfNeeded()
            self.setGradient(0.5)
            
            self.isLoginBtn = false
            
            self.view.bringSubviewToFront(self.tableView)
            
            self.setMenuItems()
        }
    }
    
    @objc fileprivate func signOut(){
        UIView.animate(withDuration: 0.5) {
            self.emailView.alpha = 1
            self.passwordView.alpha = 1
            self.registrationBtn.alpha = 1
            self.noLoginBtn.alpha = 1
            self.loginBtn.alpha = 1
            
            self.emailView.isUserInteractionEnabled = true
            self.passwordView.isUserInteractionEnabled = true
            self.registrationBtn.isUserInteractionEnabled = true
            self.noLoginBtn.isUserInteractionEnabled = true
            self.loginBtn.isUserInteractionEnabled = true
            
            self.requestSupportBtn.alpha = 0
            self.requestSupportBtn.isUserInteractionEnabled = false
            self.tableView.alpha = 0
            self.centerConstrain.constant = -36
            self.bottomBgConstrain.constant = 0
            self.tableViewTopSpaceConstrain.constant = 700
            self.requestSupportBtnConstrain.constant = 700
            
            self.loginBtn.setTitle("LOGIN".localized(), for: .normal)
            self.view.layoutIfNeeded()
            self.setGradient(0.01)
            
            self.isLoginBtn = true
            
            self.view.sendSubviewToBack(self.tableView)
        }
    }
    
    // MARK: - Outlets methods
    @IBAction func clickOnLogin(_ sender: Any) {
        self.view.endEditing(true)
        if !self.isLoading{
            if let email = self.email.text, !email.isEmptyOrWhitespace(){
                if let password = self.password.text, !password.isEmptyOrWhitespace(){
                    self.activityIndicator.startAnimating()
                    self.isLoading = true
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        self.activityIndicator.stopAnimating()
                        self.isLoading = false
                        guard user != nil else {
                            if let error = error {
                                if let errCode = AuthErrorCode(rawValue: error._code) {
                                    switch errCode {
                                    case .userNotFound:
                                        self.showAlert("ALERT".localized(), messegeText: "LOGIN_USER_NOT_FOUND".localized())
                                    case .wrongPassword:
                                        self.showAlert("ALERT".localized(), messegeText: "LOGIN_INCORRECT_USER_OR_PASSWORD".localized())
                                    default:
                                        self.showAlert("ALERT".localized(), messegeText: "\("ERRORS_ERROR".localized()): \(error.localizedDescription)")
                                    }
                                }
                                return
                            }
                            assertionFailure("user and error are nil")
                            return
                        }
                        
                        if  let u = Auth.auth().currentUser, u.isEmailVerified{
                            self.signIn()
                        }else{
                            self.showAlert("ALERT".localized(), messegeText: "LOGIN_EMAIL_NOT_VERIFIED".localized())
                        }
                    })
                }else{
                    self.showAlert("ALERT".localized(), messegeText: "REGISTRATION_PASSWORD_FILL".localized())
                }
            }else{
                self.showAlert("ALERT".localized(), messegeText: "REGISTRATION_EMAIL_FILL".localized())
            }
        }
        
    }
    
    @IBAction func forgotPassClick(_ sender: Any) {
        self.view.endEditing(true)
        if !self.isLoading{
            if let email = self.email.text, !email.isEmptyOrWhitespace(){
                self.password.text = ""
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                    if let error = error {
                        if let errCode = AuthErrorCode(rawValue: error._code) {
                            switch errCode {
                            case .userNotFound:
                                self.showAlert("ALERT".localized(), messegeText: "LOGIN_USER_NOT_FOUND".localized())
                            case .wrongPassword:
                                self.showAlert("ALERT".localized(), messegeText: "LOGIN_INCORRECT_USER_OR_PASSWORD".localized())
                            default:
                                self.showAlert("ALERT".localized(), messegeText: "\("ERRORS_ERROR".localized()): \(error.localizedDescription)")
                            }
                        }
                        return
                    }else{
                        self.showAlert("ALERT".localized(), messegeText: "LOGIN_INSTRUCTIONS_FORGOT_IS_SENDEN".localized())
                    }
                }
                return
            }else{
                self.showAlert("ALERT".localized(), messegeText: "REGISTRATION_EMAIL_FILL".localized())
            }
        }
    }
    
    @IBAction func skipBtnClick(_ sender: Any) {
        self.showAlert("ALERT".localized(), messegeText: "LOGIN_SKIP_ALERT_TEXT".localized())
        self.signIn()
    }
    
    @IBAction func requestSupportClick(_ sender: Any) {
        performSegue(withIdentifier: "showRequestSupport", sender: self)
    }
}

// MARK: - Table view delegate
extension LoginViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Table view data source
extension LoginViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = self.items[indexPath.row]
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: id){
            switch (id){
            case "contact":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "CONTACTS".localized()
                break
            case "checklist":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "CHECKLIST".localized()
                break
            case "goldenRules":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "GOLDEN_RULES".localized()
                break
            case "account":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "ACCOUNT".localized()
                break
            case "changeLanguage":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "CHANGE_LANGUAGE".localized()
                break
            case "learnMore":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "LEARN_MORE".localized()
                break
            case "disclaimer":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "DISCLAIMER".localized()
                break
            case "impressum":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "IMPRESSUM".localized()
                break
            case "logout":
                (cell as! LoginMenuTableViewCell).titleLbl.text = "LOGOUT".localized()
                break
            case "dynamicPage":
                (cell as! LoginMenuTableViewCell).titleLbl.text = self.dynamicPages[indexPath.row - self.firstGroupContent.count].title
                break
            default:
                break
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.items[indexPath.row] == "logout"{
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError)")
            } catch {
                print("Unknown error.")
            }
        }
        
        if self.items[indexPath.row] == "account"{
            if let u = Auth.auth().currentUser, u.isEmailVerified{
                self.performSegue(withIdentifier: "showAccount", sender: self)
            }else{
                self.performSegue(withIdentifier: "showLoginOrRegister", sender: self)
            }
        }
        
        if self.items[indexPath.row] == "dynamicPage"{
            self.selectedDynamicPage = self.dynamicPages[indexPath.row - self.firstGroupContent.count]
            if let selDynamicPage = self.selectedDynamicPage{
                if !selDynamicPage.isOpenInExternalBrowser{
                    self.performSegue(withIdentifier: "showDynamicPages", sender: self)
                }else{
                    let strNoBreak = selDynamicPage.сontent.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).trim()
                        
                    if let url = URL(string: strNoBreak){
                        UIApplication.shared.open(url, options: [:])
                    }
                }
            }
        }
        return indexPath
    }
}
