//
//  SignupViewController.swift
//  TaskHero
//
//  Created by Christopher Webb-Orenstein on 9/28/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase

final class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    let store = UserDataStore.sharedInstance
    let signupView = SignupView()
    var emailInvalidated = false
    let CharacterLimit = 11
    let helpers = Helpers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signupView)
        edgesForExtendedLayout = []
        navigationController?.navigationBar.tintColor = UIColor.white
        setupSignupView()
        signupView.signupButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    fileprivate func setupSignupView() {
        signupView.layoutSubviews()
        signupView.emailField.delegate = self
        signupView.confirmEmailField.delegate = self
        signupView.usernameField.delegate = self
        signupView.passwordField.delegate = self
    }
    
    // MARK: - UITextfield Delegate Methods
    // Checks for character length (implemented for username length) if characters exceed allowed range, text field will no longer except new characters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)  -> Bool {
        if textField == signupView.usernameField {
            if let userName = signupView.usernameField.text {
                let userNameString = userName as NSString
                let updatedText = userNameString.replacingCharacters(in: range, with: string)
                return updatedText.characters.count <= CharacterLimit
            }
        }
        return true
    }
    
    func handleRegister() {
        view.endEditing(true)
        let loadingView = LoadingView()
        loadingView.showActivityIndicator(viewController: self)
        guard let email = signupView.emailField.text,
            let password = signupView.passwordField.text,
            let username = signupView.usernameField.text,
            let confirmFieldText = self.signupView.confirmEmailField.text else {
                loadingView.hideActivityIndicator(viewController:self)
                print("Form is not valid")
                return
        }
        guard validateEmailInput(email: email, confirm: confirmFieldText) == true else { helpers.setupErrorAlert(viewController: self); return }
        signupLogic(email: email, password: password, username: username, loadingView: loadingView)
    }
    
    func signupLogic(email: String, password: String, username: String, loadingView: LoadingView) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                loadingView.hideActivityIndicator(viewController: self)
                print(error ?? "unable to get specific error")
                return
            }
            guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            let newUser = self.helpers.createUser(uid: uid, username: username, email: email)
            self.setupUser(user: newUser)
            let tabBar = TabBarController()
            self.helpers.loadTabBar(tabBar:tabBar)
        }
    }
    
    func setupUser(user: User) {
        store.firebaseAPI.registerUser(user: user)
        store.currentUserString = FIRAuth.auth()?.currentUser?.uid
        store.firebaseAPI.setupRefs()
        store.currentUser = user
    }
    

}
