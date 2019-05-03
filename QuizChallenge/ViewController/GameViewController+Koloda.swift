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
            let countdownView: CountdownView = .fromNib()
            countdownView.startCallback = {
                self.startTimer()
                self.kolodaView.swipe(arc4random_uniform(2) == 1 ? .left : .right)
            }
            return countdownView
        } else {
            return SimpleQuestionView.fromNib()
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
