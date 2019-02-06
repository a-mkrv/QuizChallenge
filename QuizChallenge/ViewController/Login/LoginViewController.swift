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
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loginButton.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1)
            loginButton.layer.borderWidth = 2
    }
    
    // MARK: Actions

    @IBAction func pressLoginButton(_ sender: Any) {
        
        loginButton.startAnimation()
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1)
            
            DispatchQueue.main.async(execute: { () -> Void in
                //self.loginButton.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 0.8011558219)
                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainController = storyboard.instantiateViewController(withIdentifier: "MainSB") as? MainViewController
                    //self.view.window?.switchRootViewController(mainController!)
                    self.present(mainController!, animated: true, completion: nil)
                })
            })
        })
    
        return
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MainSB") as? MainViewController
        UserDefaults.standard.isLoggedIn = true
        
        let setSettings = SettingsModel()
        try! RealmManager.shared.storeObject(setSettings)
        
        
        self.view.window?.switchRootViewController(mainController!)
    }
    
    @IBAction func editingLoginField(_ sender: Any) {
    
    }
    
    @IBAction func editingPasswordField(_ sender: Any) {

    }
    
}
