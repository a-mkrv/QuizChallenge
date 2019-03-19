//
//  RandomOpponentViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RandomOpponentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    @IBOutlet weak var mainView: IBView!
    
    var questionCategory = "All"
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    
    func goToGameInformations() {
        
        //TODO: Instead of 3 seconds, need to make a request for active games every second
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            
            let navigationController = self.presentingViewController as? UINavigationController
            self.dismiss(animated: false) {
                let gameVC = CommonHelper.loadViewController(from: "Main", named: "GameInfoSB") as! GameInformationViewController
                navigationController?.pushViewController(gameVC, animated: true)
            }
        }
    }
 
}
