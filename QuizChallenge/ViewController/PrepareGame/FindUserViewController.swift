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
        
        usernameSearchButton.rx.tap
            .subscribe(onNext: {  [weak self] _ in
                let opponentModalVC = CommonHelper.loadViewController(from: "Main", named: "OpponentScreen") as! OpponentViewController
                opponentModalVC.modalPresentationStyle = .overCurrentContext
                self?.present(opponentModalVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - IBAction

    @IBAction func randomSearch(_ sender: Any) {
        
    }
    
}
