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

class FindUserViewController: UIViewController {

    // MARK: - UI Outlets

    @IBOutlet weak var userSearchTextField: IBTextField!
    @IBOutlet weak var usernameSearchButton: IBButton!
   
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupUI()
    }

    // MARK: - Setup UI

    fileprivate func setupUI() {
        userSearchTextField.text?.removeAll()
        userSearchTextField.lineColor = UIColor.lightGray
        usernameSearchButton.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - Setup RX
    
    fileprivate func setupRx() {
        
        userSearchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            self.userSearchTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        let usernameValid = userSearchTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        usernameValid
            .bind(onNext: { [weak self] (isValid) in
                self?.usernameSearchButton.isEnabled = isValid
                self?.usernameSearchButton.backgroundColor = isValid ? UIColor.lightRoyal : UIColor.lightGray
                self?.userSearchTextField.lineColor = isValid ? UIColor.lightRoyal : UIColor.lightGray
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
