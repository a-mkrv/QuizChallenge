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
