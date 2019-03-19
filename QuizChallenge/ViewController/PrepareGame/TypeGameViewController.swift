//
//  TypeGameViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 26/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import ViewAnimator

enum TypeGame {
    case Once
    case Tourney
}

class TypeGameViewController: BaseViewController {
    
    @IBOutlet weak var quickGameView: IBView!
    @IBOutlet weak var tourneyGameView: IBView!
    @IBOutlet weak var trainGameView: IBView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(views: [quickGameView, tourneyGameView, trainGameView], animations: [AnimationType.zoom(scale: 0.5)], animationInterval: 0.13)
    }
    
    @IBAction func quickGamePress(_ sender: Any) {
        goToPrepareQuestion(.Once)
    }
    
    @IBAction func tournamentPress(_ sender: Any) {
        goToPrepareQuestion(.Tourney)
    }
    
    func goToPrepareQuestion(_ type: TypeGame) {
        let prepareGameVC = CommonHelper.loadViewController(from: "Main", named: "PrepareQuestionSB") as! PrepareGameViewController
        prepareGameVC.gameInfo.type = type
        self.navigationController?.pushViewController(prepareGameVC, animated: true)
    }
}
