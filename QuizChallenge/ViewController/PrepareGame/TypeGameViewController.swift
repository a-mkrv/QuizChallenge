//
//  TypeGameViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 26/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

enum TypeGame {
    case Once
    case Tourney
}

class TypeGameViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
