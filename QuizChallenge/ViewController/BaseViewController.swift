//
//  BaseViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 13/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBAction func pressBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func showNetworkUnavailableAlert() {
        PopUpHelper.showErrorAlert(from: self, type: .networkUnavailable)
    }
    
    func showWrongAlert() {
        PopUpHelper.showErrorAlert(from: self, type: .common, title: "Error", descript: "Something went wrong", buttonText: "Retry")
    }
}

// MARK: - Keyboard Notification Selectors

extension BaseViewController {
    
    func keyboardSubscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardUnsubscribe() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
