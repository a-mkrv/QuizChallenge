//
//  GameViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 23/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import Koloda

class GameViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var timeProgressView: IBProgressView!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet weak var answer1Button: IBButton!
    @IBOutlet weak var answer2Button: IBButton!
    @IBOutlet weak var answer3Button: IBButton!
    @IBOutlet weak var answer4Button: IBButton!
    
    // MARK: - Properties
    let quiz: Quiz? = nil
    
    private var timeForQuestion: Float = 2000
    private var counter: Float = 0.0
    private var timer: Timer!
    private let answer = 3
    
    private var buttons: [IBButton] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UI & Time Config
        buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        timeForQuestion = Float((quiz?.timeForQuestion ?? 20) * 100)
        
        timeLabel.text = "20 seconds"
        timeProgressView.setProgress(0.0, animated: false)
        
        // Koloda Config
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.backgroundColor = .clear
        kolodaView.countOfVisibleCards = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeProgressView.setProgress(1.0, animated: true)
    }
    
    // MARK: - Timer methods
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgressView() {
        counter += 1
        timeLabel.text = "\(20 - Int(counter / timeForQuestion * 20)) seconds"
        timeProgressView.setProgress(1 - counter / timeForQuestion, animated: true)
        
        if counter == timeForQuestion {
            nextQuestion()
        }
    }
    
    // Invalid timer
    private func invalidTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Question Methods
    private func nextQuestion() {
        
        invalidTimer()
        counter = 0
        timeProgressView.setProgress(1.0, animated: true)
        _ = buttons.map({
            $0.backgroundColor = .white
            $0.isEnabled = true
            $0.alpha = 1
        })
        
        kolodaView.swipe(arc4random_uniform(2) == 1 ? .left : .right)
        enabledButton(button: addTimeButton, isEnable: true)
        enabledButton(button: hintButton, isEnable: true)
        
        startTimer()
    }

    func enabledButton(button: UIButton, isEnable: Bool) {
        button.isEnabled = isEnable
        button.alpha = isEnable ? 1 : 0.5
    }
    
    //MARK: - Actions
    @IBAction func pressAnswer(_ sender: IBButton) {
        if sender.tag != answer {
            buttons[sender.tag - 1].backgroundColor = .red
        } else {
            buttons[sender.tag - 1].backgroundColor = .green
        }
        
        invalidTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextQuestion()
        }
    }
    
    @IBAction func getHint(_ sender: Any) {
        var leaveButton = Int(arc4random_uniform(4))
        
        repeat {
            leaveButton = Int(arc4random_uniform(4))
        } while (leaveButton == answer)
        
        for i in 0...3 {
            enabledButton(button: buttons[i], isEnable: (i == answer || i == leaveButton))
        }
    }
    
    @IBAction func addTime(_ sender: Any) {
        counter = 0
    }
    
    @IBAction func skipQuestion(_ sender: Any) {
        nextQuestion()
    }
    
    @IBAction func cancelGame(_ sender: Any) {
        timer.invalidate();
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
