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

protocol SocialLoginHandlerDelegate {
    func didReceivedToken(_ token: String, fromSocialNetwork socialNetwork: SocialNetwork)
    func authorize()
}

enum SocialNetwork {
    case Facebook
    case Vkontakte
    case Google
}

// Facade Login Controller
class AuthController: NSObject {
    
    var delegate: SocialLoginHandlerDelegate?
    
    override init() {
        super.init()
        
       
    }
    
    func doLogin(type: SocialNetwork) {
        switch type {
        case .Facebook:
            authorizeFacebook()
        case .Vkontakte:
            authorizeVK()
        case .Google:
            print("Google Login")
        }
    }

    
    
    // MARK: - Facebook
    private func authorizeFacebook() {
        
        let facebookLogin: FBSDKLoginManager = FBSDKLoginManager()
        facebookLogin.loginBehavior = FBSDKLoginBehavior.native
        facebookLogin.logOut() // logout with old credentials
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: (self.delegate as! UIViewController)) {
            (result, error) in
            
            guard error == nil else {
                Logger.error(msg: error!.localizedDescription)
                return
            }
            
            guard result!.isCancelled != false else {
                Logger.error(msg: "User cancelled login.")
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
            
            guard error == nil, let result = result else {
                Logger.error(msg: "Facebook parse result is nil or an error occurred")
                return
            }
            
            if let token = FBSDKAccessToken.current().tokenString {
                self.delegate?.didReceivedToken(token, fromSocialNetwork: .Facebook)
                Logger.info(msg: "FB Access token: \(token)")
                Logger.info(msg: "FB Response Data: \(result)")
            }
        })
    }
}

