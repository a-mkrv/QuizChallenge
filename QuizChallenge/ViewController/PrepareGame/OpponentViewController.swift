//
//  OpponentViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 25/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class OpponentViewController: UIViewController {

    @IBOutlet weak var profileImageView: IBImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    
    @IBOutlet weak var mainView: IBView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let viewPosition = mainView.frame.origin.y
        mainView.frame.origin.y = 0
        
        UIView.springAnimate(animateCompletion: {
            self.mainView.frame.origin.y = viewPosition
        })
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startGame(_ sender: Any) {
    
    }
}
