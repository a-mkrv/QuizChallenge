//
//  LoginViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import TransitionButton

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var loginTextField: IBTextField!
    @IBOutlet weak var passwordTextField: IBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1)
        loginButton.layer.borderWidth = 2
    }
    
    // MARK: Actions
    
    @IBAction func pressLoginButton(_ sender: Any) {
        
        guard CommonHelper.checkNetworkStatus() else {
            CommonHelper.alert.showAlertView(title: "Error", subTitle: "It seems you forgot to turn on the Internet", buttonText: "Try Again", type: .error)
            return
        }
        
        guard checkCredentials(type: .login, for: loginTextField) && checkCredentials(type: .password, for: passwordTextField) else {
            CommonHelper.alert.showAlertView(title: "Error", subTitle: "Incorrect login or password", buttonText: "Try Again", type: .error)
            return
        }
        
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        let parameters = ["name" : login, "password" : password]
        
        loginButton.startAnimation()
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.5, execute: {
            
            NetworkManager.shared.doLogin(with: parameters, completion: { (result) in
                
                switch result {
                case .success(_):
                    self.successLogin()
                    
                case .error(let error, let code):
                    Logger.error(msg: "Error - \(error). code - \(code)")                    
                    Logger.info(msg: "Only for debug") // //self.errorLogin()
                    self.successLogin()
                }
            })
        })
    }
    
    @IBAction func editingLoginField(_ sender: Any) {
        _ = checkCredentials(type: .login, for: loginTextField)
    }
    
    @IBAction func editingPasswordField(_ sender: Any) {
        _ = checkCredentials(type: .password, for: passwordTextField)
    }
    
    // MARK: - Private methods
    
    fileprivate func successLogin() {
        DispatchQueue.main.async {
            self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                self.doLogin()
            })
        }
    }
    
    fileprivate func errorLogin() {
        self.loginButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                self.loginButton.shake()
            }
        })
    }
    
    fileprivate func doLogin() {
        try! RealmManager.shared.storeObject(SettingsModel())
        UserManager.shared.isLoggedIn = true
        Router.rootMainVC()
    }
}
