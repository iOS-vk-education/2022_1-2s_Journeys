//
//  auth.swift
//  RollsAuth
//
//  Created by Maxim Kozlitin on 17.11.2022.
//

import UIKit
import Foundation
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    enum authStatus {
        case authorized
        case unauthorized
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Log in"
        label.textAlignment = .center
        
        return label
    }()
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email address"
        emailField.autocapitalizationType = .none
        emailField.layer.borderWidth = 1
        
        return emailField
    }()
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderWidth = 1
        
        return passwordField
    }()
    private let actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.layer.borderWidth = 1
        
        return actionButton
    }()
    
    private var currentAuthStatus : authStatus = .unauthorized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = JourneysColors.Dynamic.Background.lightColor
        
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.currentUserAuthStatus() {
            self.changeAuthStatus()
        }
        else {
            self.setAuthStatus()
        }
    }
    
    private func setupFonts() {
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        emailField.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        passwordField.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
    }
    
    private func setupColors() {
        emailField.textColor = JourneysColors.Dynamic.Text.mainTextColor
        passwordField.textColor = JourneysColors.Dynamic.Text.mainTextColor
        actionButton.setTitleColor(JourneysColors.Dynamic.Text.mainTextColor, for: .normal)
        actionButton.backgroundColor = JourneysColors.Dynamic.Background.lightColor
    }
    
    private func setupAuthForm() {
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40,
                                  height: 50)
        
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                     width: view.frame.size.width-40,
                                     height: 50)
        
        actionButton.frame = CGRect(x: 20,
                                    y: passwordField.frame.origin.y+passwordField.frame.size.height+30,
                                    width: view.frame.size.width-40,
                                    height: 50)
        
        self.setAuthStatus()
    }
    
    private func setupSubviews() {
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(actionButton)

        setupColors()
        setupFonts()
        setupAuthForm()
    }
    
    private func currentUserAuthStatus() -> Bool {
        return FirebaseAuth.Auth.auth().currentUser != nil
    }
    
    private func setAuthStatus() {
        switch self.currentAuthStatus {
            case .authorized:
                self.actionButton.setTitle("Log Out", for: .normal)
                self.actionButton.addTarget(self, action: #selector(tappedLogOut), for: .touchUpInside)
                self.label.isHidden = true
                self.emailField.isHidden = true
                self.passwordField.isHidden = true
            case .unauthorized:
                self.actionButton.setTitle("Continue", for: .normal)
                self.actionButton.addTarget(self, action: #selector(tappedLogIn), for: .touchUpInside)
                self.label.isHidden = false
                self.emailField.isHidden = false
                self.passwordField.isHidden = false
        }
    }
    
    private func changeAuthStatus() {
        switch self.currentAuthStatus {
            case .authorized:
                self.currentAuthStatus = .unauthorized
                self.actionButton.removeTarget(self, action: #selector(tappedLogOut), for: .touchUpInside)
            case .unauthorized:
                self.currentAuthStatus = .authorized
                self.actionButton.removeTarget(self, action: #selector(tappedLogIn), for: .touchUpInside)
        }
        self.setAuthStatus()
    }
    
    @objc private func tappedLogOut() {
        print("Log out")
        do {
            try FirebaseAuth.Auth.auth().signOut()
            self.changeAuthStatus()
        }
        catch {
            return
        }
    }
    
    private func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account",
                                  message: "Would you like to create an account",
                                  preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    // failed to create
                    return
                }
                
                strongSelf.changeAuthStatus()
            })
            
        }))
            
            
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))
        
        present(alert, animated: true)
    }
    
    @objc private func tappedLogIn() {
        print("Log in")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else {
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            strongSelf.changeAuthStatus()
        })
    }
}

private extension AuthViewController {

    struct AuthConstants {
    }
}
