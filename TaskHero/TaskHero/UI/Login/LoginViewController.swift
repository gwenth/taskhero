//
//  LoginViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

final class LoginViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate let loginView = LoginView() /* LoginView instantiated - will be added to viewcontroller view in viewdidload */
    let manager = AppManager.sharedInstance /* User defaults data methods */
    let store = DataStore.sharedInstance
    fileprivate let loadingView = LoadingView() /* Activity indicator and background container view instantiated -
                                                   will be added to view on login button press */
    
    // ============================================
    // MARK: ViewController Initialization Methods
    // ============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        edgesForExtendedLayout = []
        print(view.superview)
        loginView.setupLogin(viewController:self)
        navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor()
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.gray, height: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.store.firebaseAPI.fetchValidUsernames()
    }
}

extension LoginViewController {
    
    // ================================
    // MARK: Login Method Extension
    // ================================
    
    /*
       - handleLogin starts by initially checking emailfield for text input formatted as valid email address - if not method returns
       - then it sets LoginViewController.view endEditting property to true
       - next loadingView (property implmemented at top) calls showActivity indicator method which takes viewController as parameter -
         pass in self.
       - sets guard condition for email and password for emailfield.text and passwordfield.text - if not returns 
       - calls firebase FIRAuth.auth.signIn method - which takes email and password 
       - FIRAuth.auth.signIn returns FIRUser and FIRError objects, if error is not nil - hides loadingView.activity indicator enters
         switch statement to return proper error message
       - sets guard condition for userID from user?.uid (FIRUser) / if not - returns
     */
    
    @objc func handleLogin() {
        checkForValidEmailInput()
        view.endEditing(true)
        loadingView.showActivityIndicator(viewController: self)
        guard let email = loginView.emailField.text, let password = loginView.passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            if error != nil {
                self.loadingView.hideActivityIndicator(viewController:self)
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("Invalid Email For Sign In")
                    default:
                        print("User Authentication Error: \(error)") }
                }
                print(error ?? "Unknown error occured when attempting sign in authentication")
                return
            }
            guard let userID = user?.uid else { return }
            
           /*
            - On global DispatchQueue with qos: userInituated sets self to unowned self
            * creates new DataStore.sharedInstance
            * sets new DataStore instance currentUserString property to userID
            * sets up FirebaseAPI database reference handles
            * calls new DataStore FirebaseAPI property and uses fetchUser method
            * sets new DataStore instance currentUser property to user returned from fetchUser method call
            * sets userDefaults proporties in AppManager to logged in 
            */

            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                let newStore = DataStore.sharedInstance
                newStore.currentUserString = userID
                newStore.firebaseAPI.setupRefs()
                newStore.firebaseAPI.fetchUser { currentUser in newStore.currentUser = currentUser }
                self.manager.setLoggedInKey(userState: true)
                self.manager.hasLoggedIn()
                
            /*  - On main thread hides loadingView.activity indicator and sets appDelegate window to tabbarcontroller */
                
                DispatchQueue.main.async {
                    self.loadingView.hideActivityIndicator(viewController: self)
                    self.setupTabBar()
                }
            }
        }
    }
    
    fileprivate func setupTabBar() {
        let tabBar = TabBarController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
    
    // Checks that text has been entered and exceeds five characters in length
    
    fileprivate func checkForValidEmailInput() {
        if loginView.emailField.text == nil || (self.loginView.emailField.text?.characters.count)! < 5 {
            loginView.textFieldAnimation()
        }
    }
}

extension LoginViewController {
    
    // ======================================
    // MARK: - Textfield delegate methods
    // ======================================
    
    // If email field selected cycles to password field / if password field cycles to emailfield.
    // Hides keyboard/ ends view editting
    // Sets textfield text color and border to selected color
    // On ending edit textfield border color are set to deselect color
    
    // On return key press
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === loginView.emailField) ? loginView.passwordField : loginView.emailField
        nextField.becomeFirstResponder()
        return true
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // selector method that Pushes SignupViewController on button tap
    @objc public func signupButtonTapped() {
        navigationController?.pushViewController(SignupViewController(), animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [unowned textField] in
            textField.textColor = Constants.Color.backgroundColor
            textField.font = Constants.signupFieldFont
            textField.layer.borderColor = Constants.Color.backgroundColor.cgColor
            textField.layer.borderWidth = 1.1
        }
    }
    
    // When no longer using input fields
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [unowned textField] in
            textField.layer.borderWidth = 1
            textField.textColor = UIColor.lightGray
            textField.layer.borderColor = Constants.Color.backgroundColor.cgColor
            self.checkForValidEmailInput()
        }
    }
}
