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
}
