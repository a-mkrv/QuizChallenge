//
//  MainViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import TransitionButton

class MainViewController: CustomTransitionViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var activeGamesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        usernameLabel.text = UserManager.shared.curUser.username
        pointsLabel.text = "Points: \(UserManager.shared.curUser.points)"
    }
}
