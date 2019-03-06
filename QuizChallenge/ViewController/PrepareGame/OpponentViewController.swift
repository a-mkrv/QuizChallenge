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
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
    }

    @IBAction func closeView(_ sender: Any) {
    
    }
    
    @IBAction func startGame(_ sender: Any) {
    
    }
}
