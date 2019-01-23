//
//  GameViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 23/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import Koloda

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
    }
    
    @IBAction func cancelGame(_ sender: Any) {
        
        print("Cancel Game")
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
