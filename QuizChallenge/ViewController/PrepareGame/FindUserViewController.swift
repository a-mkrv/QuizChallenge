//
//  FindUserViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift

class FindUserViewController: BaseViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var userSearchTextField: IBTextField!
    @IBOutlet weak var usernameSearchButton: IBButton!
    
    let disposeBag = DisposeBag()
    var gameInfo = PrepareGameInfo()
    var viewModel = PrepareGameViewModel()
    
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
            .flatMap { [unowned self] _ -> Observable<Opponent> in
                return self.viewModel.searchUserBy(name: self.userSearchTextField.text!)
            }
            .subscribe(onNext: { opponent in
                Logger.info(msg: opponent.username)
                let opponentModalVC = CommonHelper.loadViewController(named: "OpponentScreen", isModal: true) as! OpponentViewController
                self.present(opponentModalVC, animated: true, completion: nil)
                
            }, onError: { error in
                Logger.error(msg: "User not found, or error - \(error)")
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RandomSearch" {
            if let vc = segue.destination as? RandomOpponentViewController {
                vc.questionCategory = gameInfo.selectCategory ?? "All"
            }
        }
    }

}
