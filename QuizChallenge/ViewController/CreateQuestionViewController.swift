//
//  CreateQuestionViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 28/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class CreateQuestionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var createButton: IBButton!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var answer4Trailing: NSLayoutConstraint!
    @IBOutlet weak var answer3Leading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification()
        uiSetup()
    }
    
    fileprivate func uiSetup() {
        
        let insets = UIEdgeInsets(top: questionTextView.frame.height - 25, left: 0, bottom: 0, right: 0)
        questionTextView.textContainerInset = insets
        questionTextView.textColor = UIColor.lightGray
        answer3Leading.constant = -300
        answer4Trailing.constant = -300
        _ = answersView.subviews.map({ $0.backgroundColor = .clear })
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        guard let sender = sender as? UISegmentedControl else {
            return
        }
        
        if sender.selectedSegmentIndex == 0 {
            self.answer3Leading.constant = -300
            self.answer4Trailing.constant = -300
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.answer3Leading.constant = 0
            self.answer4Trailing.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension CreateQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
            UIView.animate(withDuration: 0.5, animations: {
                self.questionImageView.alpha = 0
            }, completion: { _ in
                self.questionImageView.isHidden = true
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your question!"
            textView.textColor = UIColor.lightGray
            
            self.questionImageView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.questionImageView.alpha = 1
            }
        }
    }
}

// MARK: - Keyboard Notification

extension CreateQuestionViewController {
    
    fileprivate func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 && ifAnswersInFocused() {
            self.view.frame.origin.y -= (answersView.frame.height - 20)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 && ifAnswersInFocused() {
            self.view.frame.origin.y = 0
        }
    }
    
    fileprivate func ifAnswersInFocused() -> Bool {
        for view in answersView.subviews {
            if ((view as? AnswerCreateView)?.textView.isFirstResponder)! {
                return true
            }
        }
        return false
    }
}

