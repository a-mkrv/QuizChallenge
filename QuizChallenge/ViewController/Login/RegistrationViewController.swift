//
//  RegistrationViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 04/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift
import TransitionButton

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var optionalInfoView: UIView!
    
    @IBOutlet weak var avatarImageView: IBImageView!
    @IBOutlet weak var signUpButton: TransitionButton!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var typeDataView: UIView!
    @IBOutlet weak var additionalButton: UIButton!
    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var triangleCenter: NSLayoutConstraint!
    @IBOutlet weak var keyboardViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: IBTextField!
    @IBOutlet weak var usernameTextField: IBTextField!
    @IBOutlet weak var passwordTextField: IBTextField!
    
    var optionalInfoIsShow = false
    let triangleConstraint: CGFloat = 95.0
    
    var viewModel: RegistrationViewModel?
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
        keyboardNotification()
        
        signUpButton.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1)
        signUpButton.layer.borderWidth = 2
        triangleCenter.constant = -triangleConstraint
        optionalInfoView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Button Actions
    
    @IBAction func chooseAvatarImage(_ sender: Any) {
        ImageSelector.shared.presentImagePicker(from: self) { [weak self] (image) in
            self?.avatarImageView.image = image
            self?.avatarImageView.isCircle = true
        }
    }
    
    @IBAction func chooseDataType(_ sender: UIButton) {
        
        if !optionalInfoIsShow && sender.tag == 1 {
            optionalInfoIsShow = true
            triangleCenter.constant = triangleConstraint
            animateChooseView(fromButton: generalButton, toButton: additionalButton)
            generalInfoView.flip(to: optionalInfoView)
            
        } else if optionalInfoIsShow && sender.tag == 0 {
            triangleCenter.constant = -triangleConstraint
            optionalInfoIsShow = false
            animateChooseView(fromButton: additionalButton, toButton: generalButton)
            optionalInfoView.flip(to: generalInfoView)
        }
    }
    
    private func animateChooseView(fromButton: UIButton, toButton: UIButton) {
        UIView.transition(with: fromButton, duration: 1.0, options: .transitionCrossDissolve, animations: {() -> Void in
            self.typeDataView.layoutIfNeeded()
            toButton.setTitleColor(#colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1), for: .normal)
            fromButton.setTitleColor(UIColor.darkGray, for: .normal)
        })
    }
    
    private func errorRegistration() {
        self.signUpButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                self.signUpButton.shake()
            }
        })
    }
    
    private func successRegistrtion() {
        self.signUpButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                CommonHelper.alert.showAlertView(title: "Registration Seccess", subTitle: "\nCongratulations, you are registered. \nClick the button to start the game\n", buttonText: "Start", type: .success, isAutoHide: false) {                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
}

// MARK: - Setup Model & Rx

extension RegistrationViewController {
    
    func setViewModel(_ viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate func setupRx() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        bindModel(fields: [usernameTextField,
                           emailTextField,
                           passwordTextField],
                  models: [viewModel.usernameViewModel,
                           viewModel.emailViewModel,
                           viewModel.passwordViewModel])
        
        // Tap Button
        signUpButton.rx.tap
            .filter { [unowned self] _ in
                var isValid = false
                _ = self.viewModel?.isValidAllData().subscribe(onNext: {status in
                    isValid = status
                })
                if !isValid {
                    self.signUpButton.shake()
                    return false
                } else { return true }
            }
            .flatMap { [unowned self] _ -> Observable<LoginResponse> in
                self.signUpButton.startAnimation()
                return (self.viewModel?.registration())!
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .noInterner:
                    self.signUpButton.stopAnimation()
                    CommonHelper.alert.showAlertView(title: "Error",
                                                     subTitle: "It seems you forgot to turn on the Internet",
                                                     buttonText: "Try Again",
                                                     type: .error)
                case .success:
                    self.successRegistrtion()
                case .failCredentials:
                    self.errorRegistration()
                case .none:
                    Logger.info(msg: "None Case Response")
                }
            }).disposed(by: disposeBag)
    }
    
    fileprivate func bindModel(fields: [IBTextField], models: [ValidationViewModel?]) {
        
        for i in 0 ..< fields.count {
            
            if let model = models[i] {
                fields[i].rx.text.orEmpty
                    .bind(to: model.data)
                    .disposed(by: disposeBag)
                
                model.validateCredentials()
                    .observeOn(MainScheduler.instance)
                    .bind { fields[i].lineColor = $0 ? UIColor.royal : .red }
                    .disposed(by: disposeBag)
            }
        }
    }
}

// MARK: - Keyboard Notification Selectors

extension RegistrationViewController {
    
    fileprivate func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardViewTopConstraint.constant == 0 {
            keyboardViewTopConstraint.constant = -20
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardViewTopConstraint.constant != 0 {
            keyboardViewTopConstraint.constant = 0
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
