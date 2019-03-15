//
//  FindUserViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FindUserViewController: BaseViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var userSearchTextField: IBTextField!
    @IBOutlet weak var usernameSearchButton: IBButton!
    
    let disposeBag = DisposeBag()
    var gameInfo = PrepareGameInfo()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    // MARK: - Setup RX
    
    fileprivate func setupRx() {
        
        userSearchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            self.userSearchTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        let usernameValid = userSearchTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .share(replay: 1)
        
        usernameValid
            .bind(onNext: { [weak self] (isValid) in
                self?.usernameSearchButton.isEnabled = isValid
                self?.usernameSearchButton.setTitleColor(isValid ? UIColor(named: "LightBlue") : UIColor.lightGray, for: .normal)
            })
            .disposed(by: disposeBag)
        
        // Tap Button
        usernameSearchButton.rx.tap
            .flatMap { [unowned self] _ -> Observable<Result<Opponent>> in
                return self.searchOpponentByName(userName: "amakarov")
            }
            .subscribe(onNext: { response in
                
                switch response {
                case .success(let user):
                    print(user.username)
                    let opponentModalVC = CommonHelper.loadViewController(from: "Main", named: "OpponentScreen") as! OpponentViewController
                    opponentModalVC.modalPresentationStyle = .overCurrentContext
                    self.present(opponentModalVC, animated: true, completion: nil)
                    
                case .error(let error):
                    print(error)
                    CommonHelper.alert.showAlertView(title: "Error",
                                                     subTitle: "It seems you forgot to turn on the Internet",
                                                     buttonText: "Try Again",
                                                     type: .error)
                }
            }).disposed(by: disposeBag)
    }
    
    func searchOpponentByName(userName: String) -> Observable<Result<Opponent>> {
        
        return Observable.create{ observer in
            
            // TODO: 
            let user: APIParameters = ["opponent": userName]
            NetworkManager.shared.searchOpponent(with: user)
                .subscribe(onNext: { opponent in
                    observer.onNext(Result.success(opponent))
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func randomSearch(_ sender: Any) {
        
    }
}
