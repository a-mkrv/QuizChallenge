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

class RegistrationViewController: BaseViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var dataInputView: UIView!
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
        keyboardSubscribe()
        
        signUpButton.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1)
        signUpButton.layer.borderWidth = 2
        triangleCenter.constant = -triangleConstraint
        optionalInfoView.isHidden = true
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardUnsubscribe()
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 {
            if UIDevice().screenType == .iPhoneX {
                view.frame.origin.y -= 60
            } else {
                view.frame.origin.y -= (dataInputView.frame.origin.y - 20)
            }
        }
    }

    // MARK: - Button Actions
    
    @IBAction func chooseAvatarImage(_ sender: Any) {
        ImageSelector.shared.presentImagePicker(from: self) { [weak self] (image) in
            self?.avatarImageView.image = image
            self?.avatarImageView.isCircle = true
        }
    }
    
    // Flipping registration fields
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
        
        for textField in optionalInfoView.subviews[0].subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        
        for textField in generalInfoView.subviews[0].subviews where textField is UITextField {
            textField.resignFirstResponder()
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
        signUpButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                self.signUpButton.shake()
            }
        })
    }
    
    private func successRegistration() {
        signUpButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                PopUpHelper.showSimpleAlert(from: self, type: .common, title: "Registration Success", descript: "\nCongratulations, you are registered. \nClick the button to start the game\n", buttonText: "Start", isAutoHide: false) {
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
            .flatMap { [unowned self] _ -> Observable<ResponseState> in
                self.signUpButton.startAnimation()
                return (self.viewModel?.registration())!
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .networkUnavailable:
                    self.signUpButton.stopAnimation()
                    self.showNetworkUnavailableAlert()
                case .success:
                    self.successRegistration()
                case .invalidStatusCode:
                    self.errorRegistration()
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
                
                // Keyboard Return Key Handler
                fields[i].rx.controlEvent([.editingDidEndOnExit]).subscribe { text in
                    if i == fields.count - 1 {
                        fields[i].resignFirstResponder()
                    } else {
                        fields[i + 1].becomeFirstResponder()
                    }
                    }.disposed(by: disposeBag)
            }
        }
    }
}
