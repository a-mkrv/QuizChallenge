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

class RandomOpponentViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    @IBOutlet weak var mainView: IBView!
    
    var searchUserObservable: Observable<Opponent> = .empty()
    var questionCategory = "All"
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUserObservable
            .subscribe(onNext: { (opponent) in
                Logger.debug(msg: opponent.username)
            }, onError: { [unowned self] (error) in
                Logger.error(msg: error)
                switch error as! ResponseState {
                case .success: break
                case .networkUnavailable:
                    self.showNetworkUnavailableAlert()
                case .invalidStatusCode:
                    self.showWrongAlert()
                }
            }).disposed(by: disposeBag)
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
        
        let navigationController = self.presentingViewController as? UINavigationController
        self.dismiss(animated: false) {
            let gameVC = CommonHelper.loadViewController(from: "Main", named: "GameInfoSB") as! GameInformationViewController
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}
