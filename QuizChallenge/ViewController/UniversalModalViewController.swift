//
//  UniversalModalViewController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 21/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

// MARK: Alert Type

enum ModalErrorType {
    case common
    case networkUnavailable
}

enum ModalSimpleType {
    case common
    case done
}

enum ModalType {
    case confirm
    case error(type: ModalErrorType)
    case simple(type: ModalSimpleType)
}

// MARK: - PopUp View

class UniversalModalViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: IBImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: IBImageView!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var firstButton: IBButton!
    @IBOutlet weak var secondButton: IBButton!
    @IBOutlet weak var separateLineView: UIView!
    
    // MARK: - Variables for init popup
    
    var typeModal = ModalType.simple(type: .common)
    var titleText: String?
    var descriptionText: String?
    var firstButtonText: String?
    var secondButtonText: String?
    var firstButtonCompletion: EmptyClosure?
    var secondButtonCompletion: EmptyClosure?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configAndShowView()
        
        let viewPosition = mainView.frame.origin.y
        mainView.frame.origin.y = 0
        
        UIView.springAnimate(duration: 0.8, animateCompletion: {
            self.mainView.frame.origin.y = viewPosition
        })
    }
    
    // MARK: Open methods
    
    func showSimpleAlert(type: ModalSimpleType, title: String? = nil, descript: String, buttonText: String, completion: EmptyClosure? = nil) {
        setContentView(type: ModalType.simple(type: type), title: title, descript: descript, firstButton: buttonText, firstCompletion: completion)
    }
    
    func showConfirmAlert(title: String?, descript: String, negativeButton: String, positiveButton: String, negativeCompletion: @escaping EmptyClosure, positiveCompletion: @escaping EmptyClosure) {
        setContentView(type: .confirm, title: title, descript: descript, firstButton: negativeButton, secondButton: positiveButton, firstCompletion: negativeCompletion, secondCompletion: positiveCompletion)
    }
    
    func showErrorAlert(type: ModalErrorType, title: String? = nil, descript: String?, buttonText: String?, completion: EmptyClosure? = nil) {
        
        if type == .networkUnavailable {
            setContentView(type: ModalType.error(type: type), title: "Network Error", descript: "Please check your network connection", firstButton: "Ok!", firstCompletion: completion)
        } else {
            setContentView(type: ModalType.error(type: type), title: title, descript: descript ?? "Something went wrong", firstButton: buttonText ?? "Ok!", firstCompletion: completion)
        }
    }
    
    private func setContentView(type: ModalType, title: String? = nil, descript: String, firstButton: String, secondButton: String? = nil, firstCompletion: EmptyClosure? = nil, secondCompletion: EmptyClosure? = nil) {
        
        typeModal = type
        titleText = title
        descriptionText = descript
        firstButtonText = firstButton
        secondButtonText = secondButton
        firstButtonCompletion = firstCompletion
        secondButtonCompletion = secondCompletion
    }
    
    private func configAndShowView() {
        
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        firstButton.setTitle(firstButtonText, for: .normal)
        
        switch typeModal {
        case .confirm:
            firstButton.setTitleColor(UIColor.lightGray, for: .normal)
            secondButton.setTitleColor(UIColor.royal, for: .normal)
            backgroundImage.image = UIImage(named: "PurpleRec")
            imageView.backgroundColor = UIColor.lightRoyal
            imageView.image = UIImage(named: "confirmAlert")
        case .error(type: .networkUnavailable):
            firstButton.setTitleColor(UIColor.errorRed, for: .normal)
            backgroundImage.image = UIImage(named: "OrangeRec")
            imageView.image = UIImage(named: "networkAlert")
            imageView.backgroundColor = UIColor(named: "Color-6")
        case .error(type: .common):
            firstButton.setTitleColor(UIColor.errorRed, for: .normal)
            backgroundImage.image = UIImage(named: "OrangeRec")
            imageView.image = UIImage(named: "errorAlert")
            imageView.backgroundColor = UIColor(named: "Color-6")
        case .simple(type: .common):
            firstButton.setTitleColor(UIColor.royal, for: .normal)
            backgroundImage.image = UIImage(named: "PurpleRec")
            imageView.image = UIImage(named: "alert")
            imageView.backgroundColor = UIColor.lightRoyal
        case .simple(type: .done):
            firstButton.setTitleColor(UIColor.royal, for: .normal)
            backgroundImage.image = UIImage(named: "BlueRec")
            imageView.image = UIImage(named: "doneAlert")
            imageView.backgroundColor = UIColor(named: "Color-5")
        }
        
        if let text = secondButtonText {
            secondButton.setTitle(text, for: .normal)
        } else {
            separateLineView.removeFromSuperview()
            secondButton.removeFromSuperview()
        }
        
        if case ModalType.confirm = typeModal {
            // Auto dismiss disabled for confirm view
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.dismissModalView()
            }
        }
    }
    
    func dismissModalView() {
        UIView.springAnimate(animateCompletion: {
            self.mainView.frame.origin.y = -self.mainView.frame.height
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: - Buttons action callback
    
    @IBAction func pressFirstButton(_ sender: Any) {
        firstButtonCompletion?()
        dismissModalView()
    }
    
    @IBAction func pressSecondButton(_ sender: Any) {
        secondButtonCompletion?()
        dismissModalView()
    }
}
