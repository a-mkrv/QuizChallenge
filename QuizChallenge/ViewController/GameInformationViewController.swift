//
//  GameInformationViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 06/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class GameInformationViewController: UIViewController {

    @IBOutlet weak var gamer1ImageView: IBImageView!
    @IBOutlet weak var gamer1NameLabel: UILabel!
    
    @IBOutlet weak var gamer2ImageView: IBImageView!
    @IBOutlet weak var gamer2NameLabel: UILabel!
    
    @IBOutlet weak var gameResultTableView: UITableView!
    @IBOutlet weak var nextButton: IBButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pressBack(_ sender: Any) {
    
    }
}