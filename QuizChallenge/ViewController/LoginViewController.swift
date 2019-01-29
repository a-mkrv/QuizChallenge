//
//  LoginViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions

    @IBAction func pressLoginButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MainSB") as? MainViewController
        UserDefaults.standard.isLoggedIn = true
        self.view.window?.switchRootViewController(mainController!)
    }
    
    @IBAction func editingLoginField(_ sender: Any) {
    
    }
    
    @IBAction func editingPasswordField(_ sender: Any) {

    }
    
}
