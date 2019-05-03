//
//  AnswerCreateView.swift
//  QuizChallenge
//
//  Created by A.Makarov on 28/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class AnswerCreateView: UIView {
    
    var view: UIView!
    var isFillText = false
    
    @IBOutlet weak var textView: UITextView!
    @IBInspectable var isCorrect: Bool = false {
        didSet {
            textView.text = isCorrect ? "Correct answer" : "Incorrect answer"
            textView.textColor = UIColor.lightGray
            view.layer.borderColor = isCorrect ? UIColor.lightRoyal.cgColor : UIColor.lightRed.cgColor
        }}
    
    // MARK: - Setup view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    // MARK: Load Nib
    
    private func nibSetup() {
        
        view = getNibView()
        view.frame = bounds
        uiSetup()
        addSubview(view)
    }
    
    // MARK: Prepare UI
    
    private func uiSetup() {
        let insets = UIEdgeInsets(top: textView.frame.height / 2 - 5, left: 0, bottom: 5, right: 0)
        textView.textContainerInset = insets
        textView.delegate = self
        
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.lightRed.cgColor
        view.layer.borderWidth = 2
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}

// MARK: - UITextViewDelegate
extension AnswerCreateView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        isFillText = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            resetTextView()
        }
    }
    
    func resetTextView() {
        textView.text = isCorrect ? "Correct answer" : "Incorrect answer"
        textView.textColor = UIColor.lightGray
        isFillText = false
    }
}
