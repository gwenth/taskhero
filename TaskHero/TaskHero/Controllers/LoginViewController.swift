//
//  LoginViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let loginView = LoginView()
    
        
    let store = DataStore.sharedInstance
    let schema = Database.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        
        loginView.layoutSubviews()
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.07, green:0.59, blue:1.00, alpha:1.0)
        
        
        self.navigationController?.navigationBar.setBottomBorderColor(color: UIColor.gray, height: 1.0)
        loginView.emailField.delegate = self
        loginView.passwordField.delegate = self
        loginView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let operationQueue = OperationQueue()
        
        
        let operation = BlockOperation(block: { () -> Void in
            self.loginView.loginButton.addTarget(self, action: #selector(self.handleLogin), for: .touchUpInside)
        })
        
        operationQueue.addOperation(operation)
        
        operationQueue.maxConcurrentOperationCount = 2
        
        operationQueue.qualityOfService = .userInitiated
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func signupButtonTapped() {
        navigationController?.pushViewController(SignupViewController(), animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0)
        textField.layer.borderColor = UIColor(red:0.21, green:0.22, blue:0.24, alpha:1.0).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func handleLogin() {
        view.endEditing(true)
        let loadingView = LoadingView()
        
        loadingView.showActivityIndicator(viewController: self)
        
        guard let email = loginView.emailField.text, let password = loginView.passwordField.text else {
            
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                loadingView.hideActivityIndicator(viewController:self)
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("in use")
                    default:
                        print("Create User Error: \(error)")
                    }    
                }
            
                print(error ?? "error")
                return
            }
            
            
            
            //self.store.currentUserString = FIRAuth.auth()?.currentUser?.uid
            loadingView.hideActivityIndicator(viewController: self)
            Constants().delay(0.9) {
                print("here 2")
                self.loginView.emailField.layer.backgroundColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0).cgColor
                self.loginView.emailField.textColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
                
                self.loginView.passwordField.layer.backgroundColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0).cgColor
                self.loginView.passwordField.textColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
            }

            
            guard let userID = user?.uid else { return }
        
            self.store.currentUserString = userID
            self.store.fetchUser(completion: { user in
                self.store.currentUser = user
                print(user)
            })
            let tabBar = TabBarController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBar
        })
    }
}


extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
