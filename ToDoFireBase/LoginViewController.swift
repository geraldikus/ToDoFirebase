//
//  ViewController.swift
//  ToDoFireBase
//
//  Created by Anton on 12.05.23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var containerView: UIStackView!
    
    
    var originalContainerViewFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                 let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else
        { return }
            
            // Сместите контейнер вверх, чтобы избежать перекрытия клавиатурой
            let intersectedFrame = containerView.frame.intersection(keyboardFrame)
            let keyboardHeight = keyboardFrame.height
            containerView.frame.origin.y -= keyboardHeight / 2
        
        }
        
        @objc func keyboardDidHide(notification: Notification) {
            // Восстановите исходное положение контейнера после скрытия клавиатуры
            containerView.frame = originalContainerViewFrame
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Удалите обработчики уведомлений при исчезновении контроллера
            NotificationCenter.default.removeObserver(self)
        }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }
    
    
}

