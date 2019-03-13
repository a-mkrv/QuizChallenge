//
//  Router.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 12/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class Router {
    
    // MARK: Func for load in AppDelegate
    static func setupRootVC(){
        
        var initialViewController: UIViewController?
        
        if (UserManager.shared.isLoggedIn) {
            initialViewController = CommonHelper.loadViewController(from: "Main", named: "MainSB") as? MainViewController
        } else {
            if UserDefaults.standard.isShowWelcomeScreen {
                Router.rootLoginVC()
            } else {
                initialViewController = CommonHelper.loadViewController(from: "Login", named: "WelcomeSB") as? WelcomeViewController
            }
        }
        
        if let initVC = initialViewController {
            let navigationController = UINavigationController(rootViewController: initVC)
            navigationController.isNavigationBarHidden = true
            navigationController.navigationBar.isTranslucent = true
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.white
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = window
        }
    }
    
    // MARK: Switch root view controller with animate
    static func switchAnimateRootVС(_ viewController: UIViewController, duration: TimeInterval = 0.7, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.isHidden = true
        
        guard let appWindow = (UIApplication.shared.delegate as! AppDelegate).window else {
            completion?()
            return
        }
        
        UIView.transition(with: appWindow, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            appWindow.rootViewController = navigationController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
    
    // MARK: Open login vc as a root
    static func rootLoginVC() {
        if let loginViewController: LoginViewController = CommonHelper.loadViewController(from: "Login", named: "LoginSB") as? LoginViewController {
            loginViewController.setViewModel(LoginViewModel())
            Router.switchAnimateRootVС(loginViewController)
        } else {
            Logger.error(msg: "Some error with opening the login screen")
        }
    }
    
    // MARK: Open main vc as a root
    static func rootMainVC() {
        if let mainViewController = CommonHelper.loadViewController(from: "Main", named: "MainSB") as? MainViewController {
            Router.switchAnimateRootVС(mainViewController)
        } else {
            Logger.error(msg: "Some error with opening the main screen")
        }
    }
}
