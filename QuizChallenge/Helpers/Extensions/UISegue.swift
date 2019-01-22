//
//  UISegue.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

//MARK: Custom segue transition
class FadeInPushSegue: UIStoryboardSegue {
    
    var animated: Bool = true
    
    override func perform() {
        
        let sourceViewController = self.source
        let destinationViewController = self.destination
        let transition: CATransition = CATransition()
        
        transition.type = CATransitionType.fade
        sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
    }
}
