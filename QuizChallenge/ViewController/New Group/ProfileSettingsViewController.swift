//
//  ProfileSettingsViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 26/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var userDataView: IBView!
    @IBOutlet weak var userImageView: IBImageView!
    
    var isShowKeyboard = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Interaction Methods
    
    @objc func keyboardWillAppear() {
        isShowKeyboard = true
    }
    
    @objc func keyboardWillDisappear() {
        isShowKeyboard = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isShowKeyboard else {
            touchesBegan(touches, with: event)
            view.endEditing(true)
            return
        }
        
        if let touch = touches.first, touch.view != userDataView, touch.view != userImageView  {
            dismiss(animated: true, completion: nil)
        }
    }
}
