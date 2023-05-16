//
//  ViewController.swift
//  ToDoFireBase
//
//  Created by Anton on 12.05.23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var containerView: UIStackView!
    
    
    var originalContainerViewFrame: CGRect!
    var isContainerViewShifted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warnLabel.alpha = 0
        loginButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
                
        originalContainerViewFrame = containerView.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
        
        passwordTextField.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField == passwordTextField && emailTextField.text?.isEmpty == true {
                warnLabel.alpha = 1
                warnLabel.text = "Please fill in the email field first."
                return false
            }
            return true
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
           if textField == emailTextField {
               passwordTextField.isEnabled = validateEmail()
               
               if passwordTextField.isEnabled {
                   warnLabel.alpha = 0
               }
           }
       }
    
    @objc func keyboardDidShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, emailTextField.isFirstResponder else {
                
                     return
                 }
            
            // Сместите контейнер вверх, чтобы избежать перекрытия клавиатурой
        if !isContainerViewShifted {
            UIView.animate(withDuration: 0.7, delay: 0) { [self] in
                let intersectedFrame = self.containerView.frame.intersection(keyboardFrame)
                let keyboardHeight = intersectedFrame.height
                containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
            isContainerViewShifted = true
        }
        
    }
        
        @objc func keyboardDidHide(notification: Notification) {
            // Восстановите исходное положение контейнера после скрытия клавиатуры
            
            UIView.animate(withDuration: 0.7, delay: 0) { [self] in
                //self.containerView.frame = originalContainerViewFrame
                containerView.transform = .identity
            }
            isContainerViewShifted = false
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Удалите обработчики уведомлений при исчезновении контроллера
            NotificationCenter.default.removeObserver(self)
        }
    
    func validateEmail() -> Bool {
            guard let email = emailTextField.text, !email.isEmpty else {
                warnLabel.alpha = 1
                warnLabel.text = "Please fill in the email field first."
                return false
            }
            warnLabel.alpha = 0
            return true
        }
    
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        passwordTextField.isEnabled = validateEmail()

                if sender.text?.isEmpty == true && passwordTextField.isFirstResponder {
                    warnLabel.alpha = 1
                    warnLabel.text = "Please fill in the email field first."
                } else {
                    warnLabel.alpha = 0
                }
       }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        })
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if error == nil {
                if user != nil {
                    self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                }
            }
        }
    }
    
}

