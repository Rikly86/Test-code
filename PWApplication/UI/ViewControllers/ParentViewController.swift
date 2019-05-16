//
//  ParentViewController.swift
//  PWApplication
//
//  Created by Valery Cheremisin on 26/04/2019.
//  Copyright © 2019 Valery Cheremisin. All rights reserved.
//

import Foundation
import UIKit

open class ParentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var centerConstrain: NSLayoutConstraint?
    
    // MARK: - Properties
    internal var tapGesture: UITapGestureRecognizer?
    internal var centralConstrainFirstPosition:CGFloat = -36
    
    // MARK: - Life cicle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func initKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Show/hide keyboard methods
    internal func removeTapGesture(){
        if let tap = tapGesture{
            view.removeGestureRecognizer(tap)
        }
    }
    
    internal func addTapGesture(){
        removeTapGesture()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector( self.tapByScreen))
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func tapByScreen(){
        view.endEditing(true)
    }
    
    @objc internal func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                if centerConstrain != nil{
                    centerConstrain!.constant = centralConstrainFirstPosition
                }
                removeTapGesture()
            } else {
                if let h = endFrame?.size.height{
                    if centerConstrain != nil{
                        centerConstrain!.constant = self.getCentrainConstrainSecondPosition(h)
                    }
                    addTapGesture()
                }else{
                    if centerConstrain != nil{
                        centerConstrain!.constant = centralConstrainFirstPosition
                    }
                    removeTapGesture()
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    internal func getCentrainConstrainSecondPosition(_ height:CGFloat)->CGFloat{
        return centralConstrainFirstPosition - height/2
    }
}

extension ParentViewController{
    internal func showAlert(_ titleText: String, messegeText:String){
        let alertView = UIAlertController(title: titleText,
                                          message: messegeText, preferredStyle:.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
extension ParentViewController : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
