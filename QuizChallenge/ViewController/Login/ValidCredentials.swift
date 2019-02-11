//
//  ValidCredentials.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 11/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

enum Credentials {
    case login
    case password
}

func checkCredentials(type credentials: Credentials, for textField: IBTextField) -> Bool {
    
    guard let text = textField.text else {
        return false
    }
    
    var predicate = NSPredicate()
    
    switch credentials {
    case .login:
        predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]{5,}")
    case .password:
        predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]{5,}")
    }
    
    if predicate.evaluate(with: text) {
        textField.lineColor = UIColor(named: "RoyalColor")!
        return true
    } else {
        textField.lineColor = .red
        return false
    }
}
