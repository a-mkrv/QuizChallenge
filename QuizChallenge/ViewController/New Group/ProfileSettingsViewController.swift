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
    
    @IBOutlet weak var emailTextField: IBTextField!
    @IBOutlet weak var usernameTextField: IBTextField!
    @IBOutlet weak var passwordTextField: IBTextField!
    @IBOutlet weak var ageTextField: IBTextField!
    @IBOutlet weak var nameTextField: IBTextField!
    @IBOutlet weak var cityTextField: IBTextField!
    @IBOutlet weak var confPasswordTextField: IBTextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var generalSaveButton: UIButton!
    
    var isShowKeyboard = false

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotification()
        setCurrentUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setCurrentUserData() {
        let curUser = UserManager.shared.curUser
        emailTextField.text = curUser.email
        usernameTextField.text = curUser.username
        nameTextField.text = curUser.realName
        ageTextField.text = String(curUser.age)
        cityTextField.text = curUser.city
    }
}

// MARK: - Keyboard Notification Settings

extension ProfileSettingsViewController {
    
    func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
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
