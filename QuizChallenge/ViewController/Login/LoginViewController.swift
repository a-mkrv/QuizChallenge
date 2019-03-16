//
//  LoginViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit
import RxSwift
import TransitionButton

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var loginTextField: IBTextField!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var vkLoginButton: UIButton!
    @IBOutlet weak var passwordTextField: IBTextField!
    
    var viewModel: LoginViewModel?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    func setViewModel(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup RX
    
    fileprivate func setupRx() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        // View
        loginTextField.rx.text.orEmpty
            .bind(to: viewModel.usernameViewModel.data)
            .disposed(by: disposeBag)
    
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        // View Model
        viewModel.usernameViewModel.validateCredentials()
            .observeOn(MainScheduler.instance)
            .bind { self.loginTextField.lineColor = $0 ? UIColor.royal : .red }
            .disposed(by: disposeBag)
    
        viewModel.passwordViewModel.validateCredentials()
            .observeOn(MainScheduler.instance)
            .bind { self.passwordTextField.lineColor = $0 ? UIColor.royal : .red }
            .disposed(by: disposeBag)
        
        // Keyboard Return Key Handler
        loginTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { text in
            self.passwordTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { text in
            self.passwordTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        // Tap Button
        loginButton.rx.tap
            .filter { [unowned self] _ in
                var isValid = false
                _ = self.viewModel?.isUserNameAndPasswordValid().subscribe(onNext: {status in
                    isValid = status
                })
                if !isValid {
                    self.loginButton.shake()
                    return false
                } else { return true }
            }
            .flatMap { [unowned self] _ -> Observable<LoginResponse> in
                self.loginButton.startAnimation()
                return (self.viewModel?.serverNativeLogin())!
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .noInternet:
                    self.loginButton.stopAnimation()
                    CommonHelper.alert.showAlertView(title: "Error",
                                                     subTitle: "It seems you forgot to turn on the Internet",
                                                     buttonText: "Try Again",
                                                     type: .error)
                case .success:
                    self.successLogin()
                case .failCredentials:
                    self.errorLogin()
                case .none:
                    Logger.info(msg: "None Case Response")
                }
            }).disposed(by: disposeBag)
        
        fbLoginButton.rx.tap
            .flatMap { [unowned self] _ -> Observable<LoginResponse> in
                return (self.viewModel?.socialNetworkAuth(with: .Facebook))!
            }
            .subscribe(onNext: { status in
                print(status)
            })
            .disposed(by: disposeBag)
        
        vkLoginButton.rx.tap
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterSegue" {
            let vc = segue.destination as! RegistrationViewController
            vc.setViewModel(RegistrationViewModel())
        }
    }

    // MARK: - Private methods
    
    fileprivate func setupUI() {
        loginTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
        loginTextField.lineColor = UIColor.royal
        passwordTextField.lineColor = UIColor.royal
        loginButton.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.3568627451, blue: 0.8666666667, alpha: 1)
        loginButton.layer.borderWidth = 2
    }
    
    fileprivate func successLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                self.doLogin()
            })
        })
    }
    
    fileprivate func errorLogin() {
        self.loginButton.stopAnimation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async {
                self.loginButton.shake()
            }
        })
    }
    
    fileprivate func doLogin() {
        do {
            try RealmManager.shared.storeObject(SettingsModel())
            UserManager.shared.isLoggedIn = true
            Router.rootMainVC()
        } catch {
            Logger.error(msg: "Realm Storage Error: \(error.localizedDescription) \nUnable to login")
        }
    }
}
