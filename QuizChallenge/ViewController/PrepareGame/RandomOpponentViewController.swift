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
    @IBOutlet weak var mainView: IBView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOpponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        activityIndicator.startAnimating()
        
        let viewPosition = mainView.frame.origin.y
        mainView.frame.origin.y = 0
        
        UIView.springAnimate(animateCompletion: {
            self.mainView.frame.origin.y = viewPosition
        })
    }
    
    @IBAction func goWaitingToMainScreen(_ sender: Any) {
        
        let navigationController = self.presentingViewController as? UINavigationController
        
        self.dismiss(animated: true) {
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func searchOpponent() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            
            let navigationController = self.presentingViewController as? UINavigationController
            self.dismiss(animated: false) {
                let gameVC = CommonHelper.loadViewController(from: "Main", named: "GameSB") as! GameViewController
                navigationController?.pushViewController(gameVC, animated: true)
            }
        }
    }
 
}
