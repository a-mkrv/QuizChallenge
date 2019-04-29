//
//  RestorePassViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 29/04/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift

class RestorePassViewController: BaseViewController {

    @IBOutlet weak var emailTextField: IBTextField!
    @IBOutlet weak var restoreButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
            .bind(to: restoreButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    @IBAction func restorePassword(_ sender: UIButton) {
        PopUpHelper.showSimpleAlert(from: self, type: .common, descript: "Check your E-mail and recover your password!", buttonText: "Ok") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
