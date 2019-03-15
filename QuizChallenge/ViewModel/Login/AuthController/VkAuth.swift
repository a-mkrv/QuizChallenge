//
//  VkAuth.swift
//  QuizChallenge
//
//  Created by A.Makarov on 15/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import SwiftyVK

class VkAuth: SwiftyVKDelegate {
    
    let VK_APP_ID:String = "6288855"
    
    func doAuth() {
         VK.setUp(appId: VK_APP_ID, delegate: self)
    }
    
    private func authorizeVK() {
        if (VK.sessions.default.state != .authorized) {
            VK.sessions.default.logIn(
                onSuccess: { info in
                    //didReceivedToken(info["access_token"]!, fromSocialNetwork: .Vkontakte)
            },
                onError: { error in
                    
            }
            )
        } else {
            VK.sessions.default.logOut()
            
            authorizeVK()
        }
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        // Called when SwiftyVK attempts to get access to user account
        // Should return a set of permission scopes
        return [.email]
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
        // Should display given view controller from current top view controller
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        // Called when user grants access and SwiftyVK gets new session token
        // Can be used to run SwiftyVK requests and save session data
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        // Called when existing session token has expired and successfully refreshed
        // You don't need to do anything special here
    }
    
    func vkTokenRemoved(for sessionId: String) {
        // Called when user was logged out
        // Use this method to cancel all SwiftyVK requests and remove session data
    }
}
