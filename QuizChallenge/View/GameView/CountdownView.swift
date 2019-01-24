//
//  CountdownView.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 24/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class CountdownView: UIView {
    
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var prepareLabel: UILabel!
    
    var startCallback: (() -> ())?
    var timer: Timer!
    var seconds = 3
    
    override func draw(_ rect: CGRect) {
        circleView.animateCircle(duration: 3)
        timerLabel.text = String(seconds)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel() {
        seconds -= 1
        timerLabel.text = String(seconds)
        
        if seconds == 0 {
            timer.invalidate()
            timerLabel.text = "Go"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startCallback?()
            }
        }
    }
}
