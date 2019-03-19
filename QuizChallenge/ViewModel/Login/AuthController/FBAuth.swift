//
//  FBAuth.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 16/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


class FBAuth: Authorizable {
    
    // MARK: - Facebook
    func authorize(complition: @escaping authComplitionData) {
        
        let facebookLogin: FBSDKLoginManager = FBSDKLoginManager()
        facebookLogin.loginBehavior = FBSDKLoginBehavior.native
        facebookLogin.logOut() // logout with old credentials
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: UIViewController()) {
            (result, error) in
            
            guard error == nil else {
                Logger.error(msg: error!.localizedDescription)
                complition(.error(error))
                return
            }
            
            if let fbResult = result {
                if fbResult.isCancelled {
                    Logger.error(msg: "User cancelled login.")
                    complition(.error(nil))
                } else if fbResult.grantedPermissions != nil, fbResult.grantedPermissions.contains("email") {
                    self.readFacebookLoginResult(complition: { result in
                        complition(result)
                    })
                }
                
            } else {
                Logger.error(msg: "Error Facebook Login. Check granted permissions")
                complition(.error(nil))
            }
        }
    }
    
    private func readFacebookLoginResult(complition: @escaping authComplitionData) {
        
        guard FBSDKAccessToken.current() == nil else {
            Logger.info(msg: "Token already received")
            return
        }
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, locale, location, birthday, bio"]).start(completionHandler: { (connection, result, error) in
            
            guard error == nil, let result = result else {
                Logger.error(msg: "Facebook parse result is nil or an error occurred")
                complition(.error(nil))
                return
            }
            
            if let token = FBSDKAccessToken.current().tokenString {
                Logger.info(msg: "FB Access token: \(token)")
                Logger.info(msg: "FB Response Data: \(result)")
                
                guard let userDict = result as? [String: Any] else {
                    complition(.error(nil))
                    return
                }
                
                let name  = userDict["name"] as? String ?? ""
                let email = userDict["email"] as? String ?? ""
                let age  = userDict["birthday"] as? Int ?? 0 // FIXME
                let location = userDict["location"] as? String ?? ""
                
                // Add later
                if let picture = userDict["picture"] as? [String:Any] ,
                    let imgData = picture["data"] as? [String:Any] ,
                    let _ = imgData["url"] as? String {
                }
                
                let authData = AuthData(name: name, email: email, age: age, location: location, token: token)
                complition(.success(authData))
            }
        })
    }
    
}
