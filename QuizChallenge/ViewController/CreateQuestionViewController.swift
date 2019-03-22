//
//  CreateQuestionViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 28/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift

class CreateQuestionViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var createButton: IBButton!
    @IBOutlet weak var typeQuestion: IBTextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var answer4Trailing: NSLayoutConstraint!
    @IBOutlet weak var answer3Leading: NSLayoutConstraint!
    
    var countAnswer = 2
    let disposeBag = DisposeBag()
    
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
            countAnswer = 2
            answer3Leading.constant = -300
            answer4Trailing.constant = -300
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                _ = self.answersView.subviews.map( {
                    if $0.tag == 2 {
                        $0.isHidden = true
                    }})
            }
        } else {
            countAnswer = 4
            answer3Leading.constant = 0
            answer4Trailing.constant = 0
            _ = self.answersView.subviews.map( {
                if $0.tag == 2 {
                    $0.isHidden = false
                }})
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func sendQuestion(_ sender: Any) {

        guard let question = questionTextView.text, let type = typeQuestion.text, question.count > 7, type.count > 4 else {
            PopUpHelper.showErrorAlert(from: self, type: .common, descript: "Question or type are missing or too short", buttonText: "Ok")
            return
        }
  
        if let answers = answersQuestion() {
            var fullAnswers = [APIParameters]()
            
            for (index, answer) in answers.enumerated() {
                fullAnswers.append(["text": answer, "is_correct": index == 0])
            }
            
            let params: APIParameters = ["text": question,
                                         "type": "text",
                                         "category": type,
                                         "answers": fullAnswers
            ]
            
            NetworkManager.shared.createQuestion(with: params)
                .subscribe(onNext: { [unowned self] status in
                    PopUpHelper.showSimpleAlert(from: self, type: .common, title: "Thanks!", descript: "\nThank you for updating our database of questions. \n\nYou get 10 coins", buttonText: "Fine", isAutoHide: false, completion: {
                        self.questionTextView.text.removeAll()
                        self.typeQuestion.text?.removeAll()
                        _ = (self.answersView.subviews as? [AnswerCreateView])?.map{
                            $0.textView.resignFirstResponder()
                            $0.resetTextView()
                        }
                    })
                    }, onError: { [unowned self] error in
                        PopUpHelper.showErrorAlert(from: self, type: .common, descript: "There was an error sending a question", buttonText: "Try Again")
                }).disposed(by: disposeBag)
        } else {
            PopUpHelper.showErrorAlert(from: self, type: .common, descript: "Please, enter all answer", buttonText: "Ok")
        }
    }
}

extension CreateQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
            UIView.animate(withDuration: 0.5, animations: {
                self.questionImageView.alpha = 0.3
            }, completion: { _ in
                //self.questionImageView.isHidden = true
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your question!"
            textView.textColor = UIColor.lightGray
            
            //self.questionImageView.isHidden = false
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
    
    fileprivate func answersQuestion() -> [String]? {
        let answers = (answersView.subviews as? [AnswerCreateView])?.sorted{$0.tag < $1.tag}.enumerated().filter({ (element) -> Bool in
            
            let (index, view) = element
            if index >= countAnswer {
                return false
            }
            if let text = view.textView.text, text != "Incorrect answer", text != "Correct answer" {
                return true
            }
            return false
        }).map({ (element) -> String in
            let (_, view) = element
            return view.textView.text
        })
        
        return answers!.count == countAnswer ? answers! : nil
    }
}

