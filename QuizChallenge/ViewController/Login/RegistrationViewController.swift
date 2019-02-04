//
//  RegistrationViewController.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 04/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var optionalInfoView: UIView!
    
    @IBOutlet weak var typeDataView: UIView!
    @IBOutlet weak var additionalButton: UIButton!
    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var triangleCenter: NSLayoutConstraint!
    
    var optionalInfoIsShow = false
    let triangleConstraint: CGFloat = 95.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        triangleCenter.constant = -triangleConstraint
        optionalInfoView.isHidden = true
    }
    
    // MARK: - Button Actions
    
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
}
