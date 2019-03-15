//
//  AuthController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 15/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

enum SocialLogin {
    case Facebook
    case Vkontakte
    case Google
}

// Facade Login Controller
class AuthController {
    
    func doLogin(type: SocialLogin, from viewController: UIViewController) {
        switch type {
        case .Facebook:
            loginFacebook(from: viewController)
        case .Vkontakte:
            print("VK Login")
        case .Google:
            print("Google Login")
        }
    }
    
    // MARK: - Facebook
    private func loginFacebook(from: UIViewController) {
        
        let facebookLogin: FBSDKLoginManager = FBSDKLoginManager()
        facebookLogin.loginBehavior = FBSDKLoginBehavior.native
        facebookLogin.logOut() // logout with old credentials
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: from) {
            (result, error) in
            
            guard error == nil else {
                Logger.error(msg: error!.localizedDescription)
                from.dismiss(animated: true, completion: nil)
                return
            }
            
            guard result!.isCancelled != false else {
                from.dismiss(animated: true, completion: nil)
                return
            }
        
            if let fbResult = result, fbResult.grantedPermissions != nil, fbResult.grantedPermissions.contains("email") {
                self.readFacebookLoginResult()
            } else {
                Logger.error(msg: "Error Facebook Login. Check granted permissions")
            }
        }
    }
    
    private func readFacebookLoginResult() {
        
        guard FBSDKAccessToken.current() == nil else {
            Logger.info(msg: "Token already received")
            return
        }
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, locale, location, birthday, bio"]).start(completionHandler: { (connection, result, error) in
            if result == nil {
                print(error?.localizedDescription ?? "")
            }
            else{
                let accessToken = FBSDKAccessToken.current().tokenString
                Logger.info(msg: "FB Access token: \(accessToken ?? "nil")")
                Logger.info(msg: "FB Response Data: \(result ?? "nil")")
            }
        })
        
    }
}

