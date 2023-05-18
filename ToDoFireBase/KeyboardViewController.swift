//
//  KeyboardViewController.swift
//  ToDoFireBase
//
//  Created by Anton on 18.05.23.
//

import UIKit

class KeyboardViewController: UIViewController {
    
    var warnLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var containerView: UIStackView!
    
    var originalContainerViewFrame: CGRect!
    var isContainerViewShifted = false
    
    init(warnLabel: UILabel, emailTextField: UITextField, passwordTextField: UITextField, loginButton: UIButton, containerView: UIStackView) {
            self.warnLabel = warnLabel
            self.emailTextField = emailTextField
            self.passwordTextField = passwordTextField
            self.loginButton = loginButton
            self.containerView = containerView
            
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

    @objc func keyboardDidShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, emailTextField.isFirstResponder else {
                
            return
        }
            
        if !isContainerViewShifted {
            UIView.animate(withDuration: 0.7, delay: 0) { [self] in
                let intersectedFrame = self.containerView.frame.intersection(keyboardFrame)
                let keyboardHeight = intersectedFrame.height
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
            isContainerViewShifted = true
        }
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        
        UIView.animate(withDuration: 0.7, delay: 0) { [self] in
            containerView.transform = .identity
        }
        isContainerViewShifted = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    deinit {
            removeKeyboardObservers()
        }
    
    func addKeyboardObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                                  name: UIResponder.keyboardDidShowNotification,
                                                  object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
       }
       
    func removeKeyboardObservers() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
       }
}
