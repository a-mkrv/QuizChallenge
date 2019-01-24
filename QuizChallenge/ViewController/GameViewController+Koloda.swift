//
//  GameViewController+Koloda.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 24/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import Koloda

extension GameViewController: KolodaViewDataSource, KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        if index == 0 {
            let countdownView = Bundle.main.loadNibNamed("CountdownView", owner: self, options: nil)?.first as? CountdownView
            countdownView?.startCallback = {
                self.startTimer()
                self.kolodaView.swipe(arc4random_uniform(2) == 1 ? .left : .right)
            }
            return countdownView ?? UIView()
        } else {
            let questionView = Bundle.main.loadNibNamed("SimpleQuestionView", owner: self, options: nil)?.first as? SimpleQuestionView
            return questionView ?? UIView()
        }
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return 3
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
}
