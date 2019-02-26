//
//  RandomOpponentViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class RandomOpponentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in

            let navigationController = self.presentingViewController as? UINavigationController
            self.dismiss(animated: false) {
                let gameVC = CommonHelper.loadViewController(from: "Main", named: "GameSB") as! GameViewController
                navigationController?.pushViewController(gameVC, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    @IBAction func goWaitingToMainScreen(_ sender: Any) {
        
        let navigationController = self.presentingViewController as? UINavigationController
        
        self.dismiss(animated: true) {
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
 
}
